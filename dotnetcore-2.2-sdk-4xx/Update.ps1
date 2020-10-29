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
        }
    }
}

function global:au_GetLatest {
    $chunks = $Latest.PackageName -split '-'
    $info = Get-DotNetSdkUpdateInfo -Channel $chunks[1] -SdkFeatureNumber $chunks[3].TrimEnd('x') -AllVersions:$AllVersionsAsStreams
    if ($AllVersionsAsStreams)
    {
        Convert-DotNetUpdateInfoListToStreamInfo -UpdateInfo $info
    }
    else
    {
        $info
    }
}

if ($MyInvocation.InvocationName -ne '.') { update -ChecksumFor none }
