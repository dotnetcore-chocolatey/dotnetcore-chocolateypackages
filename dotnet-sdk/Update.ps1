Import-Module au
Import-Module "$PSScriptRoot\..\tools\PSModules\DotNetPackageTools\DotNetPackageTools.psm1"

function global:au_SearchReplace {
    @{
        "$PSScriptRoot\$($Latest.PackageName).nuspec" = @{
            '\[.+Release\s+Notes\]\([^)]+\)' = '[{0} Release Notes]({1})' -f (Get-DotNetReleaseDescription -ReleaseVersion $Latest.ReleaseVersion), $Latest.ReleaseNotes
            'id\=\"dotnet\w*-\d+\.\d+-sdk\"\s+version\=\"[^"]+\"' = 'id="{0}-sdk" version="{1}"' -f (Get-DotNetPackagePrefix -Version $Latest.ReleaseVersion -IncludeMajorMinor), (Get-DotNetDependencyVersionRange -BaseVersion $Latest.Version -Boundary 'Patch')
        }
    }
}

function global:au_GetLatest {
    $chunks = $Latest.PackageName -split '-'
    $latestInfo = @{
        Streams = [ordered]@{
        }
    }

    foreach ($channel in (Get-DotNetReleasesIndex).ReleasesIndex.Keys)
    {
        if (($chunks[0] -eq 'dotnet' -and [version]$channel -lt [version]'5.0') `
            -or ($chunks[0] -eq 'dotnetcore' -and [version]$channel -ge [version]'5.0'))
        {
            continue
        }

        $latestSdkInfo = Get-DotNetSdkUpdateInfo -Channel $channel -AnyFeatureNumber
        $latestInfo.Streams.Add($channel, $latestSdkInfo)
    }

    $latestInfo
}

if ($MyInvocation.InvocationName -ne '.') { update -ChecksumFor none -NoCheckUrl }
