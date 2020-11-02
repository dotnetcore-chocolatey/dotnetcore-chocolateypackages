Param
(
    [switch] $AllVersionsAsStreams
)

Import-Module au
Import-Module "$PSScriptRoot\..\tools\PSModules\DotNetPackageTools\DotNetPackageTools.psm1"

function global:au_SearchReplace {
    @{
        "$PSScriptRoot\$($Latest.PackageName).nuspec" = @{
            '\[.+Release\s+Notes\]\([^)]+\)' = '[{0} Release Notes]({1})' -f (Get-DotNetReleaseDescription -ReleaseVersion $Latest.ReleaseVersion), $Latest.ReleaseNotes
            'id\=\"dotnet\w*-\d+\.\d+-sdk-[0-9a-z]+\"\s+version\=\"[^"]+\"' = 'id="{0}-sdk-{1}xx" version="{2}"' -f (Get-DotNetPackagePrefix -Version $Latest.ReleaseVersion -IncludeMajorMinor), $Latest.SdkFeatureNumber, (Get-DotNetDependencyVersionRange -BaseVersion $Latest.Version -Boundary 'Patch')
        }
    }
}

function global:au_GetLatest {
    $chunks = $Latest.PackageName -split '-'
    $info = Get-DotNetSdkUpdateInfo -Channel $chunks[1] -AnyFeatureNumber -AllVersions:$AllVersionsAsStreams
    if ($AllVersionsAsStreams)
    {
        Convert-DotNetUpdateInfoListToStreamInfo -UpdateInfo $info
    }
    else
    {
        $info
    }
}

if ($MyInvocation.InvocationName -ne '.') { update -ChecksumFor none -NoCheckUrl }
