Set-StrictMode -Version 5

. $PSScriptRoot\Functions\Get-CallerPreference.ps1

function Write-DotNetCachedUpdateInfo
{
    [CmdletBinding(PositionalBinding = $false)]
    Param
    (
        [Parameter(Mandatory = $true)] [string] $CacheKey,
        [Parameter(Mandatory = $true)] [PSObject] $Payload
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    $timestamp = Get-Date
    $content = [pscustomobject]@{
        Timestamp = $timestamp
        Payload = $Payload
    }

    $cacheRootPath = $script:DotNetCacheRootPath
    New-Item -Path $cacheRootPath -ItemType Directory -Force | Out-Null
    $cacheFilePath = Join-Path -Path $cacheRootPath -ChildPath "$CacheKey.clixml"
    Write-Debug ('Writing cached info ''{0}'' with timestamp {1:o} to cache file {2}' -f $CacheKey, $timestamp, $cacheFilePath)
    $content | Export-Clixml -Path $cacheFilePath
}

function Read-DotNetCachedUpdateInfo
{
    [CmdletBinding(PositionalBinding = $false)]
    Param
    (
        [Parameter(Mandatory = $true)] [string] $CacheKey
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    $cacheRootPath = $script:DotNetCacheRootPath
    $cacheFilePath = Join-Path -Path $cacheRootPath -ChildPath "$CacheKey.clixml"
    if (Test-Path -Path $cacheFilePath)
    {
        Write-Debug "Reading cache file $cacheFilePath"
        $cachedInfo = Import-Clixml -Path $cacheFilePath
        $timestamp = $cachedInfo.Timestamp
        Write-Debug ('Cached info ''{0}'' timestamp is {1:o}' -f $CacheKey, $timestamp)
        $age = (Get-Date) - $timestamp
        $maxAge = $script:DotNetCacheMaxAge
        if ($age -lt $maxAge)
        {
            Write-Debug "Returning cached '$CacheKey' info (age: $age, max age: $maxAge)"
            return $cachedInfo.Payload
        }
        else
        {
            Write-Debug "Cached '$CacheKey' info is outdated, ignoring (age: $age, max age: $maxAge)"
        }
    }
    else
    {
        Write-Debug "The '$CacheKey' cache file does not exist: $cacheFilePath"
    }
}

function Get-DotNetCachedInfo
{
    [CmdletBinding(PositionalBinding = $false)]
    Param
    (
        [switch] $IgnoreCache,
        [Parameter(Mandatory = $true)] [string] $CacheKey,
        [Parameter(Mandatory = $true)] [scriptblock] $ValueFactory
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    if ($IgnoreCache)
    {
        Write-Debug "Ignoring cached $CacheKey info, as requested"
        $info = $null
    }
    else
    {
        $info = Read-DotNetCachedUpdateInfo -CacheKey $CacheKey
    }

    if ($null -eq $info)
    {
        $info = & $ValueFactory
        Write-DotNetCachedUpdateInfo -CacheKey $CacheKey -Payload $info
    }

    return $info
}

filter ConvertTo-PascalCase
{
    # will not handle single-letter chunks, but we do not expect any
    ($_ -split '[^a-z0-9]' | ForEach-Object { $_.Substring(0, 1).ToUpperInvariant() + $_.Substring(1).ToLowerInvariant() }) -join ''
}

function Get-DotNetReleasesIndexContent
{
    [CmdletBinding(PositionalBinding = $false)]
    Param ()

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    $releasesIndexUrl = 'https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/releases-index.json'
    Write-Debug "Downloading releases index file $releasesIndexUrl"
    $json = Invoke-WebRequest -UseBasicParsing -Uri $releasesIndexUrl | Select-Object -ExpandProperty Content

    Write-Debug "Parsing releases index json"
    $obj = $json | ConvertFrom-Json

    $channelIndex = @{}
    foreach ($channelInfoObj in $obj.'releases-index')
    {
        $props = @{}
        foreach ($p in $channelInfoObj.PSObject.Properties)
        {
            # convert from kebab-case for easier usage in PowerShell
            $name = $p.Name | ConvertTo-PascalCase
            $props[$name] = $p.Value
        }

        $channelInfo = [pscustomobject]$props
        $channelVersion = $channelInfo.ChannelVersion
        Write-Debug "Parsed index information for channel $channelVersion"
        $channelIndex.Add($channelVersion, $channelInfo)
    }

    Write-Debug "Parsed index information for $($channelIndex.Count) channels"
    $result = [pscustomobject]@{ ReleasesIndex = $channelIndex }
    return $result
}

function Get-DotNetReleasesIndex
{
    [CmdletBinding(PositionalBinding = $false)]
    Param
    (
        [switch] $IgnoreCache
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    $info = Get-DotNetCachedInfo -IgnoreCache:$IgnoreCache -CacheKey 'releases-index' -ValueFactory { Get-DotNetReleasesIndexContent }
    return $info
}

function Get-DotNetChannelUpdateInfoContent
{
    [CmdletBinding(PositionalBinding = $false)]
    Param
    (
        [Parameter(Mandatory = $true)] [string] $Channel,
        [Parameter(Mandatory = $true)] [PSObject] $ReleasesIndex
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    $channelInfo = $ReleasesIndex.ReleasesIndex[$Channel]
    if ($null -eq $channelInfo)
    {
        Write-Error "Channel info not found for channel: $Channel"
        return
    }

    $releasesJsonUrl = $channelInfo.ReleasesJson
    Write-Debug "Downloading channel update info file $releasesJsonUrl"
    $json = Invoke-WebRequest -UseBasicParsing -Uri $releasesJsonUrl | Select-Object -ExpandProperty Content

    Write-Debug "Parsing channel update info"
    $obj = $json | ConvertFrom-Json

    $releasesCount = $obj.releases.Length
    Write-Debug "Parsed update info for channel $($obj.'channel-version') with $($obj.releases.length) release(s)"
    $result = $obj
    return $result
}

function Get-DotNetUpdateInfo
{
    [CmdletBinding(PositionalBinding = $false, DefaultParameterSetName = 'Channel')]
    Param
    (
        [switch] $IgnoreCache,
        [Parameter(Mandatory = $true, ParameterSetName = 'Channel', ValueFromPipeline = $true)] [string[]] $Channel,
        [Parameter(Mandatory = $true, ParameterSetName = 'AllChannels')] [switch] $AllChannels
    )

    Begin
    {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        $ErrorActionPreference = 'Stop'

        $indexInfo = Get-DotNetReleasesIndex -IgnoreCache:$IgnoreCache
        if ($AllChannels)
        {
            # Let's not play paleontologists.
            $Channel = @($indexInfo.ReleasesIndex.Keys | Where-Object { $_ -notlike '1.*' })
        }
    }
    Process
    {
        foreach ($channelVersion in $Channel)
        {
            Write-Debug "Obtaining update info for channel $channelVersion"
            $info = Get-DotNetCachedInfo `
                -IgnoreCache:$IgnoreCache `
                -CacheKey "channel-$channelVersion" `
                -ValueFactory { Get-DotNetChannelUpdateInfoContent -Channel $channelVersion -ReleasesIndex $indexInfo }.GetNewClosure()
            Write-Output $info
        }
    }
}

filter Get-GuesstimatedChecksumType
{
    $length = $_.Length
    $defaultType = 'sha512'
    switch ($length)
    {
        32 {
            'sha1'
        }
        64 {
            'sha256'
        }
        128 {
            'sha512'
        }
        default {
            Write-Warning "Unrecognized checksum type (length: $length), assuming $defaultType"
            $defaultType
        }
    }
}

function Get-DotNetRuntimeComponentUpdateInfo
{
    [CmdletBinding(PositionalBinding = $false)]
    Param
    (
        [switch] $IgnoreCache,
        [ValidateSet('Runtime', 'DesktopRuntime', 'AspNetRuntime', 'RuntimePackageStore', 'AspNetCoreModuleV2')] [Parameter(Mandatory = $true)] [string] $Component,
        [Parameter(Mandatory = $true)] [string] $Channel
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    Write-Debug "Determining update info for component '$Component' in channel '$Channel' (IgnoreCache: $IgnoreCache)"
    $channelContent = Get-DotNetUpdateInfo -Channel $Channel -IgnoreCache:$IgnoreCache

    $latestRuntimeVersion = $channelContent.'latest-runtime'
    Write-Debug "Latest runtime version: $latestRuntimeVersion"
    $latestRelease = $channelContent.releases | Where-Object {
        $_.PSObject.Properties['runtime'] -ne $null <# some 2.x releases contain the SDK only #> `
        -and $_.runtime -ne $null `
        -and $_.runtime.version -eq $latestRuntimeVersion
    }

    $latestReleaseCount = ($latestRelease | Measure-Object).Count
    if ($latestReleaseCount -eq 0)
    {
        Write-Error "Could not find release with runtime version equal to latest-runtime ($latestRuntimeVersion) for channel $Channel"
        return
    }
    elseif ($latestReleaseCount -gt 1)
    {
        Write-Warning "Multiple ($latestReleaseCount) releases found with runtime version equal to latest-runtime ($latestRuntimeVersion) for channel $Channel, using the first one"
        $latestRelease = $latestRelease | Select-Object -First 1
    }

    $chocolateyCompatibleVersion = $null
    switch ($Component)
    {
        'Runtime' {
            $componentInfo = $latestRelease.runtime
            $componentVersion = $componentInfo.version

            $exe64 = $componentInfo.files | Where-Object { $_.name -like 'dotnet*win-x64.exe' }
            $exe32 = $componentInfo.files | Where-Object { $_.name -like 'dotnet*win-x86.exe' }
        }
        'DesktopRuntime' {
            # 3.0+
            $componentInfo = $latestRelease.windowsdesktop
            $componentVersion = $componentInfo.version

            $exe64 = $componentInfo.files | Where-Object { $_.name -like 'windowsdesktop*win-x64.exe' }
            $exe32 = $componentInfo.files | Where-Object { $_.name -like 'windowsdesktop*win-x86.exe' }
        }
        'AspNetRuntime' {
            # 2.1+
            $componentInfo = $latestRelease.'aspnetcore-runtime'
            $componentVersion = $componentInfo.version

            $exe64 = $componentInfo.files | Where-Object { $_.name -like 'aspnetcore-runtime*win-x64.exe' }
            $exe32 = $componentInfo.files | Where-Object { $_.name -like 'aspnetcore-runtime*win-x86.exe' }
        }
        'RuntimePackageStore' {
            # 2.0
            $componentInfo = $latestRelease.'aspnetcore-runtime'
            $componentVersion = $componentInfo.version

            $exe64 = $componentInfo.files | Where-Object { $_.name -like 'AspNetCore*RuntimePackageStore*x64.exe' }
            $exe32 = $componentInfo.files | Where-Object { $_.name -like 'AspNetCore*RuntimePackageStore*x86.exe' }
        }
        'AspNetCoreModuleV2' {
            # ANCM v2 is 2.2+, but the hosting bundle has been since forever.
            $componentInfo = $latestRelease.'aspnetcore-runtime'

            # some transitional packages installed both V1 and V2; V2 versions were higher
            $auAncmVersion = $componentInfo.'version-aspnetcoremodule' `
                | ForEach-Object { AU\Get-Version -Version $_.Trim() } `
                | Sort-Object `
                | Select-Object -Last 1
            $componentVersion = $auAncmVersion

            # To this day, version-aspnetcoremodule never had the prerelease suffix, even if the release was preview/rc,
            # so let's inherit the suffix from aspnetcore-runtime,
            # but use the version-display, because it does not contain the build number (unlike version).
            $aspDisplayVersion = $componentInfo.'version-display'
            if ($null -eq $aspDisplayVersion)
            {
                # some old releases had empty version-display
                $aspDisplayVersion = $componentInfo.version
            }

            $auAspDisplayVersion = AU\Get-Version -Version $aspDisplayVersion
            $ancmPrereleaseTag = $auAncmVersion.Prerelease
            if (-not [string]::IsNullOrEmpty($auAspDisplayVersion.Prerelease) -and [string]::IsNullOrEmpty($ancmPrereleaseTag))
            {
                $ancmPrereleaseTag = $auAspDisplayVersion.Prerelease
            }

            # ANCM version uses all four parts (10 + .NET major; .NET minor; unique build; usually .NET patch),
            # e.g. 13.1.20268.9 for .NET 3.1.9
            # The unique build is enough to distinguish between ANCM versions, so let's reserve the fourth part for package fixes.
            $ancmVersionNumbersString = $auAncmVersion.ToString(3)
            if (-not [string]::IsNullOrEmpty($ancmPrereleaseTag))
            {
                $chocolateyCompatibleVersion = AU\Get-Version -Version "${ancmVersionNumbersString}-${ancmPrereleaseTag}"
            }
            else
            {
                $chocolateyCompatibleVersion = AU\Get-Version -Version $ancmVersionNumbersString
            }

            $exe64 = $exe32 = $componentInfo.files | Where-Object { $_.name -like '*hosting*.exe' }
        }
        default { throw "Unknown component: $Component"}
    }

    $releaseVersion = $latestRelease.'release-version'
    if ($null -eq $chocolateyCompatibleVersion)
    {
        $chocolateyCompatibleVersion = AU\Get-Version -Version $componentVersion
    }

    Write-Debug "Component '$Component' in channel '$Channel': version for nuspec '$chocolateyCompatibleVersion' ComponentVersion '$componentVersion' latestRuntimeVersion '$latestRuntimeVersion' ReleaseVersion '$releaseVersion'"

    @{
        Version = $chocolateyCompatibleVersion
        ComponentVersion = $componentVersion
        URL32 = $exe32.url
        URL64 = $exe64.url
        ChecksumType32 = $exe32.hash | Get-GuesstimatedChecksumType
        ChecksumType64 = $exe32.hash | Get-GuesstimatedChecksumType
        Checksum32 = $exe32.hash
        Checksum64 = $exe64.hash
        ReleaseVersion = $releaseVersion
        ReleaseNotes = $latestRelease.'release-notes'
    }
}

function ConvertTo-DotNetSystemVersion
{
    [CmdletBinding(PositionalBinding = $false)]
    Param
    (
        [Parameter(Mandatory = $true)] [PSObject] $Version
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    if ($Version.GetType().Name -eq 'AUVersion')
    {
        $systemVersion = $Version.Version
    }
    elseif ($Version -is [Version])
    {
        $systemVersion = $Version
    }
    elseif ($Version -is [string])
    {
        $systemVersion = (AU\Get-Version -Version $Version).Version
    }
    else
    {
        throw "Unsupported argument: Version must be an AUVersion, a System.Version or a string (actual: $($Version.GetType().FullName))."
    }

    return $systemVersion
}

function Get-DotNetProductTitle
{
    [CmdletBinding(PositionalBinding = $false)]
    Param
    (
        [Parameter(Mandatory = $true)] [PSObject] $Version
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    $systemVersion = ConvertTo-DotNetSystemVersion -Version $Version

    if ($systemVersion -lt [version]'5.0')
    {
        return '.NET Core'
    }
    else
    {
        return '.NET'
    }
}

function Get-DotNetReleaseDescription
{
    [CmdletBinding(PositionalBinding = $false)]
    Param
    (
        [Parameter(Mandatory = $true)] [PSObject] $ReleaseVersion
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    $desc = '{0} {1}' -f (Get-DotNetProductTitle -Version $ReleaseVersion), $ReleaseVersion
    return $desc
}

$script:DotNetCacheRootPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("$PSScriptRoot\..\..\..\cache")
$script:DotNetCacheMaxAge = [timespan]::FromHours(1)
