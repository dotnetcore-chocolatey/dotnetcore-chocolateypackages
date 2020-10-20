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
            $Channel = @($indexInfo.ReleasesIndex.Keys)
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

$script:DotNetCacheRootPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("$PSScriptRoot\..\..\..\cache")
$script:DotNetCacheMaxAge = [timespan]::FromHours(1)
