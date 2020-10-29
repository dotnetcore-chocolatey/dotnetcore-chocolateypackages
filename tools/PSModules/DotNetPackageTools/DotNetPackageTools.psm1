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
    Write-Debug "Parsed update info for channel $($obj.'channel-version') with $releasesCount release(s)"
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
        [ValidateSet('Runtime', 'DesktopRuntime', 'AspNetRuntime', 'RuntimePackageStore', 'AspNetCoreModuleV1', 'AspNetCoreModuleV2')] [Parameter(Mandatory = $true)] [string] $Component,
        [Parameter(Mandatory = $true)] [string] $Channel,
        [switch] $AllVersions
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    Write-Debug "Determining update info for component '$Component' in channel '$Channel' (IgnoreCache: $IgnoreCache)"
    $channelContent = Get-DotNetUpdateInfo -Channel $Channel -IgnoreCache:$IgnoreCache

    if ($AllVersions)
    {
        $releases = $channelContent.releases | Where-Object {
            $null -ne $_.PSObject.Properties['runtime']  <# some 2.x releases contain the SDK only #> `
            -and $null -ne $_.runtime
        }

        $releasesCount = ($releases | Measure-Object).Count
        if ($releasesCount -eq 0)
        {
            Write-Error "Could not find any runtime release for channel $Channel"
            return
        }
    }
    else
    {
        $latestRuntimeVersion = $channelContent.'latest-runtime'
        Write-Debug "Latest runtime version: $latestRuntimeVersion"
        $latestRelease = $channelContent.releases | Where-Object {
            $null -ne $_.PSObject.Properties['runtime']  <# some 2.x releases contain the SDK only #> `
            -and $null -ne $_.runtime `
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

        $releases = @($latestRelease)
    }

    foreach ($currentRelease in $releases)
    {
        $runtimeVersion = $currentRelease.runtime.version

        $chocolateyCompatibleVersion = $null
        switch -Regex ($Component)
        {
            '^Runtime$' {
                $componentInfo = $currentRelease.runtime
                $componentVersion = $componentInfo.version

                $exe64 = $componentInfo.files | Where-Object { $_.name -like 'dotnet*win-x64.exe' }
                $exe32 = $componentInfo.files | Where-Object { $_.name -like 'dotnet*win-x86.exe' }
            }
            '^DesktopRuntime$' {
                # 3.0+
                $componentInfo = $currentRelease.windowsdesktop
                if ($null -eq $componentInfo)
                {
                    Write-Warning "Release $releaseVersion does not contain $Component, skipping"
                    $componentVersion = '0.0'
                    $exe64 = $exe32 = $null
                    break
                }

                $componentVersion = $componentInfo.version

                $exe64 = $componentInfo.files | Where-Object { $_.name -like 'windowsdesktop*win-x64.exe' }
                $exe32 = $componentInfo.files | Where-Object { $_.name -like 'windowsdesktop*win-x86.exe' }
            }
            '^AspNetRuntime$' {
                # 2.1+
                $componentInfo = $currentRelease.'aspnetcore-runtime'
                $componentVersion = $componentInfo.version

                $exe64 = $componentInfo.files | Where-Object { $_.name -like 'aspnetcore-runtime*win-x64.exe' }
                $exe32 = $componentInfo.files | Where-Object { $_.name -like 'aspnetcore-runtime*win-x86.exe' }
            }
            '^RuntimePackageStore$' {
                # 2.0
                $componentInfo = $currentRelease.'aspnetcore-runtime'
                $componentVersion = $componentInfo.version

                $exe64 = $componentInfo.files | Where-Object { $_.name -like 'AspNetCore*RuntimePackageStore*x64.exe' }
                $exe32 = $componentInfo.files | Where-Object { $_.name -like 'AspNetCore*RuntimePackageStore*x86.exe' }
            }
            '^AspNetCoreModuleV(1|2)$' {
                # .NET Core up to 2.1 => ANCM v1
                # .NET Core 2.2 => ANCM v1 and v2 (hosting bundle installs both)
                # .NET Core 3.0 and higher => ANCM v2
                $channelSystemVersion = [version]$Channel
                if ($Component -eq 'AspNetCoreModuleV1')
                {
                    if ($channelSystemVersion -le [version]'2.0')
                    {
                        throw "Although AspNetCoreModuleV1 is present in .NET Core $Channel, the release information (releases.json) does not contain its version, so this script does not support it."
                    }
                    elseif ($channelSystemVersion -gt [version]'2.2')
                    {
                        throw "AspNetCoreModuleV1 is only present in .NET Core 2.2 and earlier."
                    }
                }
                else
                {
                    if ($channelSystemVersion -lt [version]'2.2')
                    {
                        throw "AspNetCoreModuleV2 is only present in .NET Core 2.2 and later."
                    }
                }

                $componentInfo = $currentRelease.'aspnetcore-runtime'

                if ($null -eq $componentInfo.PSObject.Properties['version-aspnetcoremodule'])
                {
                    Write-Warning "Release $releaseVersion does not contain $Component version info, skipping"
                    $componentVersion = '0.0'
                    $exe64 = $exe32 = $null
                    break
                }

                # some releases (2.1.4-2.1.6) contained two version numbers; use the higher one
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

        $releaseVersion = $currentRelease.'release-version'
        if ($null -eq $chocolateyCompatibleVersion)
        {
            $chocolateyCompatibleVersion = AU\Get-Version -Version $componentVersion
        }

        $releaseNotes = $null
        if ($null -ne $currentRelease.PSObject.Properties['release-notes'])
        {
            $releaseNotes = $currentRelease.'release-notes'
        }

        Write-Debug "Component '$Component' in channel '$Channel': version for nuspec '$chocolateyCompatibleVersion' ComponentVersion '$componentVersion' runtimeVersion '$runtimeVersion' ReleaseVersion '$releaseVersion'"

        if ($null -eq $exe64)
        {
            Write-Warning "Release $releaseVersion does not contain $Component 64-bit installer info, skipping"
            continue
        }

        if ($null -eq $exe32)
        {
            Write-Warning "Release $releaseVersion does not contain $Component 32-bit installer info, skipping"
            continue
        }

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
            ReleaseNotes = $releaseNotes
        }
    }
}

function Get-DotNetSdkUpdateInfo
{
    [CmdletBinding(PositionalBinding = $false)]
    Param
    (
        [switch] $IgnoreCache,
        [Parameter(Mandatory = $true)] [string] $Channel,
        [Parameter(Mandatory = $true)] [ValidateRange(1, 999)] [int] $SdkFeatureNumber,
        [switch] $AllVersions
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    Write-Debug "Determining update info for SDK in channel '$Channel' and feature number $SdkFeatureNumber (IgnoreCache: $IgnoreCache)"
    $channelContent = Get-DotNetUpdateInfo -Channel $Channel -IgnoreCache:$IgnoreCache

    <#
    This versioning scheme is valid for 2.1 and later.
    SDKs start at X.Y.100, with the exception of 2.1, where the first SDK is 2.1.300.

    "If the SDK has 10 feature updates before a runtime feature update, version numbers roll into the 1000 series with numbers like 2.2.1000 as the feature release following 2.2.900. This situation isn't expected to occur."
    https://docs.microsoft.com/en-us/dotnet/core/versions/#versioning-details
    #>
    $minVersionInclusive = [version]"${Channel}.${SdkFeatureNumber}00"
    $maxVersionExclusive = [version]"${Channel}.$($SdkFeatureNumber + 1)00"
    Write-Debug "minVersionInclusive $minVersionInclusive maxVersionExclusive $maxVersionExclusive"
    $availableSdks = $channelContent.releases `
        | ForEach-Object {
            $release = $_
            $sdks = @($release.sdk)
            if ($null -ne $release.PSObject.Properties['sdks'] -and $null -ne $release.sdks)
            {
                $sdks = $release.sdks
            }

            foreach ($sdk in $sdks)
            {
                $v = AU\Get-Version -Version $sdk.version
                Write-Debug "Considering: $v"
                Write-Output ([pscustomobject]@{ Sdk = $sdk; SdkVersion = $v; Release = $release })
            }
        } `
        | Where-Object {
            # using System.Version comparison, so that X.Y.100-preview is treated as X.Y.100, not X.Y.0 (as AUVersion would)
            $inLeftBoundary = $minVersionInclusive -le $_.SdkVersion.Version
            $notOutsideRightBoundary = $_.SdkVersion.Version -lt $maxVersionExclusive
            $verdict = $inLeftBoundary -and $notOutsideRightBoundary
            Write-Debug "Filter result: $verdict (inLeftBoundary: $inLeftBoundary notOutsideRightBoundary: $notOutsideRightBoundary)"
            Write-Output $verdict
        } `
        | Sort-Object -Property SdkVersion -Descending

    if ($AllVersions)
    {
        $sdks = $availableSdks
    }
    else
    {
        $latestSdk = $availableSdks | Select-Object -First 1
        $sdks = @($latestSdk)
    }

    if (($sdks | Measure-Object).Count -eq 0)
    {
        Write-Error "Could not find any SDK with SdkFeatureNumber ${SdkFeatureNumber} (.${SdkFeatureNumber}xx) for channel $Channel"
        return
    }

    foreach ($sdkInfo in $sdks)
    {
        #$sdkInfo | ConvertTo-Json -Depth 100 | Write-Debug
        $currentRelease = $sdkInfo.Release
        $componentInfo = $sdkInfo.Sdk
        $componentVersion = $componentInfo.version

        $exe64 = $componentInfo.files | Where-Object { $_.name -like '*win-x64.exe' }
        $exe32 = $componentInfo.files | Where-Object { $_.name -like '*win-x86.exe' }

        $chocolateyCompatibleVersion = $sdkInfo.SdkVersion

        $releaseVersion = $currentRelease.'release-version'
        if ($null -ne $sdkInfo.Sdk.PSObject.Properties['runtime-version'])
        {
            $runtimeVersion = $sdkInfo.Sdk.'runtime-version'
        }
        else
        {
            Write-Warning "SDK version $componentVersion does not contain runtime-version info"
            $runtimeVersion = $null
        }

        $releaseNotes = $null
        if ($null -ne $currentRelease.PSObject.Properties['release-notes'])
        {
            $releaseNotes = $currentRelease.'release-notes'
        }

        Write-Debug "SDK feature number ${SdkFeatureNumber} in channel '$Channel': version for nuspec '$chocolateyCompatibleVersion' ComponentVersion '$componentVersion' matching runtime version '$runtimeVersion' ReleaseVersion '$releaseVersion'"

        if ($null -eq $exe64)
        {
            Write-Warning "SDK version $componentVersion does not contain 64-bit installer info, skipping"
            continue
        }

        if ($null -eq $exe32)
        {
            Write-Warning "SDK version $componentVersion does not contain 32-bit installer info, skipping"
            continue
        }

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
            ReleaseNotes = $releaseNotes
            RuntimeVersion = $runtimeVersion
        }
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

function Get-DotNetPackagePrefix
{
    [CmdletBinding(PositionalBinding = $false)]
    Param
    (
        [Parameter(Mandatory = $true)] [PSObject] $Version,
        [switch] $IncludeMajorMinor
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    $systemVersion = ConvertTo-DotNetSystemVersion -Version $Version

    if ($systemVersion -lt [version]'5.0')
    {
        $baseName = 'dotnetcore'
    }
    else
    {
        $baseName = 'dotnet'
    }

    if ($IncludeMajorMinor)
    {
        return ('{0}-{1}' -f $baseName, $systemVersion.ToString(2))
    }
    else
    {
        return $baseName
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

function Get-DotNetDependencyVersionRange
{
    [CmdletBinding(PositionalBinding = $false)]
    Param
    (
        [Parameter(Mandatory = $true)] [PSObject] $BaseVersion,
        [Parameter(Mandatory = $true)] [ValidateSet('Patch', 'Minor', 'Major')] [string] $Boundary # in semver lingo
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    $baseSystemVersion = ConvertTo-DotNetSystemVersion -Version $BaseVersion

    if ($baseSystemVersion.Build -lt 0)
    {
        $nextVersion = switch ($Boundary)
        {
            'Patch' { throw "Patch boundary is not supported when BaseVersion does not have at least three parts. BaseVersion = '${BaseVersion}'" }
            'Minor' { New-Object -TypeName Version -ArgumentList @($baseSystemVersion.Major, ($baseSystemVersion.Minor + 1)) }
            'Major' { New-Object -TypeName Version -ArgumentList @(($baseSystemVersion.Major + 1), 0) }
            default { throw "Unsupported Boundary: '${Boundary}'" }
        }
    }
    else
    {
        $nextVersion = switch ($Boundary)
        {
            'Patch' { New-Object -TypeName Version -ArgumentList @($baseSystemVersion.Major, $baseSystemVersion.Minor, ($baseSystemVersion.Build + 1)) }
            'Minor' { New-Object -TypeName Version -ArgumentList @($baseSystemVersion.Major, ($baseSystemVersion.Minor + 1), 0) }
            'Major' { New-Object -TypeName Version -ArgumentList @(($baseSystemVersion.Major + 1), 0, 0) }
            default { throw "Unsupported Boundary: '${Boundary}'" }
        }
    }

    $result = '[{0},{1})' -f $BaseVersion, $nextVersion
    Write-Debug "Dependency version range with '${Boundary}' boundary for base [$($BaseVersion.GetType().Name)] ${BaseVersion} = $result"
    return $result
}

function Add-DotNetSdkPackagesFromTemplate
{
    [CmdletBinding(PositionalBinding = $false)]
    Param
    (
        [switch] $IgnoreCache,
        [string] $TemplatePath = "$PSScriptRoot\..\..\..\templates\dotnetcore-X.Y-sdk-Nxx",
        [string] $DestinationPath = "$PSScriptRoot\..\..\..",
        [version] $MinChannel = [version]'2.1',
        [switch] $Update
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    $passThruArgs = $PSBoundParameters.PSObject.Copy()
    $passThruArgs.Remove('MinChannel')

    Write-Debug "Adding missing SDK packages"

    $wrappedReleasesIndex = Get-DotNetReleasesIndex
    $channels = $wrappedReleasesIndex.ReleasesIndex.Keys `
        | Where-Object { $MinChannel -le [version]$_ }

    $channelUpdateInfos = Get-DotNetUpdateInfo -Channel $channels -IgnoreCache:$IgnoreCache
    foreach ($cui in $channelUpdateInfos)
    {
        $channel = $cui.'channel-version'
        Write-Debug "Adding missing SDK packages for channel $channel"
        $sdkFeatureNumbers = $cui.releases `
            | ForEach-Object {
                if ($null -eq $_.PSObject.Properties['sdks'] -or $null -eq $_.sdks)
                {
                    @($_.sdk)
                }
                else
                {
                    $_.sdks
                }
            } `
            | ForEach-Object { AU\Get-Version $_.version } `
            | ForEach-Object { [int][Math]::Floor(($_.Version.Build) / 100) } `
            | Sort-Object -Unique

        Write-Debug "SDK feature numbers for channel ${channel}: $sdkFeatureNumbers"

        foreach ($number in $sdkFeatureNumbers)
        {
            Add-DotNetSdkFeaturePackageFromTemplate `
                -Channel $channel `
                -SdkFeatureNumber $number `
                @passThruArgs
        }
    }
}

function Add-DotNetSdkFeaturePackageFromTemplate
{
    [CmdletBinding(PositionalBinding = $false)]
    Param
    (
        [switch] $IgnoreCache,
        [Parameter(Mandatory = $true)] [string] $Channel,
        [Parameter(Mandatory = $true)] [ValidateRange(1, 999)] [int] $SdkFeatureNumber,
        [string] $TemplatePath = "$PSScriptRoot\..\..\..\templates\dotnetcore-X.Y-sdk-Nxx",
        [string] $DestinationPath = "$PSScriptRoot\..\..\..",
        [switch] $Update
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    $targetPackageName = '{0}-sdk-{1}xx' -f (Get-DotNetPackagePrefix -Version $Channel -IncludeMajorMinor), $SdkFeatureNumber
    $targetPackageTitle = 'Microsoft {0} SDK feature update {1}' -f (Get-DotNetReleaseDescription -ReleaseVersion $Channel), $SdkFeatureNumber
    $targetPackagePath = Join-Path -Path $DestinationPath -ChildPath $targetPackageName
    if (Test-Path -Path $targetPackagePath)
    {
        Write-Debug "Package '$targetPackageName' already exists."
        if (-not $Update)
        {
            return
        }
    }

    $templateName = (Get-Item -Path $TemplatePath).Name
    Write-Debug "Generating package $targetPackageName from template $templateName"

    $nuspecContent = Get-Content -Path "$TemplatePath\$templateName.nuspec"

    New-Item -ItemType Directory -Path $targetPackagePath -ErrorAction SilentlyContinue | Out-Null
    Copy-Item -Path "$TemplatePath\*" -Destination $targetPackagePath -Exclude "${templateName}.nuspec" -Recurse -Force

    $updatedNuspec = $nuspecContent `
        | ForEach-Object { $_.Replace($templateName, $targetPackageName) } `
        | ForEach-Object { $_ -replace '(?<=title\>)[^<]+', $targetPackageTitle }
    $updatedNuspec | Set-Content -Path "$targetPackagePath\$targetPackageName.nuspec"

    Remove-Item -Path "$targetPackagePath\Update.ps1" -ErrorAction SilentlyContinue
    Rename-Item -Path "$targetPackagePath\Update.template.ps1" -NewName 'Update.ps1'

    Write-Debug "Generated package $targetPackageName"
}

function Convert-DotNetUpdateInfoListToStreamInfo
{
    [CmdletBinding(PositionalBinding = $false)]
    Param
    (
        [Parameter(Mandatory = $true)] [Collections.IDictionary[]] $UpdateInfo,
        [scriptblock] $StreamNameFactory = { $_.ComponentVersion }
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    $streams = [ordered]@{}
    $UpdateInfo `
        | Sort-Object -Property { $_.Version } `
        | ForEach-Object {
            $streamName = $_ | ForEach-Object $StreamNameFactory
            $streams.Add($streamName, $_)
        }
    @{
        Streams = $streams
    }
}

$script:DotNetCacheRootPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("$PSScriptRoot\..\..\..\cache")
$script:DotNetCacheMaxAge = [timespan]::FromHours(1)
