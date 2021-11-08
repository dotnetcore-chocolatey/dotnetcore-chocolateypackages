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
            'id\=\"dotnet\w*-runtime\"\s+version\=\"[^"]+\"' = 'id="{0}-runtime" version="{1}"' -f (Get-DotNetPackagePrefix -Version $Latest.ReleaseVersion), (Get-DotNetDependencyVersionRange -BaseVersion $Latest.Version -Boundary 'Patch')
        }
    }
}

function global:au_GetLatest {
    $chunks = $Latest.PackageName -split '-'
    $latestInfo = @{
        Streams = [ordered]@{
        }
    }

    foreach ($channel in (Get-DotNetChannels))
    {
        if (($chunks[0] -eq 'dotnet' -and [version]$channel -lt [version]'5.0') `
            -or ($chunks[0] -eq 'dotnetcore' -and [version]$channel -ge [version]'5.0'))
        {
            continue
        }

        $infosForChannel = Get-DotNetRuntimeComponentUpdateInfo -Channel $channel -Component 'Runtime' -AllVersions:$AllVersionsAsStreams
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

if ($MyInvocation.InvocationName -ne '.') { update -ChecksumFor none -NoCheckUrl }
