Param
(
    [switch] $AllVersionsAsStreams
)

Import-Module au
Import-Module "$PSScriptRoot\..\tools\PSModules\DotNetPackageTools\DotNetPackageTools.psm1"

function global:au_SearchReplace {
    @{
        "$PSScriptRoot\tools\data.ps1" = @{
            "(^\s*PackageName\s*=\s*)('.*')"    = "`$1'$($Latest.PackageName)'"
            "(^\s*Url\s*=\s*)('.*')"            = "`$1'$($Latest.URL32)'"
            "(^\s*Checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            "(^\s*ChecksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
            "(^\s*Url64\s*=\s*)('.*')"          = "`$1'$($Latest.URL64)'"
            "(^\s*Checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
            "(^\s*ChecksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
        "$PSScriptRoot\$($Latest.PackageName).nuspec" = @{
            '\[.+Release\s+Notes\]\([^)]+\)' = '[{0} Release Notes]({1})' -f (Get-DotNetReleaseDescription -ReleaseVersion $Latest.ReleaseVersion), $Latest.ReleaseNotes
            "This\s+package\s+version\s+installs.+$" = 'This package version installs ASP.NET Core Module version {0}.' -f $Latest.ComponentVersion
        }
    }
}

function global:au_GetLatest {
    $latestInfo = @{
        Streams = [ordered] @{
        }
    }

    foreach ($channel in (Get-DotNetReleasesIndex).ReleasesIndex.Keys)
    {
        if ([version]$channel -lt [version]'2.2')
        {
            continue
        }

        $infosForChannel = Get-DotNetRuntimeComponentUpdateInfo -Channel $channel -Component 'AspNetCoreModuleV2' -AllVersions:$AllVersionsAsStreams
        if ($AllVersionsAsStreams)
        {
            foreach ($currentInfo in $infosForChannel)
            {
                $latestInfo.Streams.Add($currentInfo.ReleaseVersion, $currentInfo)
            }
        }
        else
        {
            $latestInfo.Streams.Add($channel, $infosForChannel)
        }
    }

    return $latestInfo
}

if ($MyInvocation.InvocationName -ne '.') { update -ChecksumFor none }
