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
            'id\=\"dotnet\w*-\d+\.\d+-runtime\"\s+version\=\"[^"]+\"' = 'id="{0}-runtime" version="{1}"' -f (Get-DotNetPackagePrefix -Version $Latest.ReleaseVersion -IncludeMajorMinor), $Latest.DepBase
            'id\=\"dotnet\w*-\d+\.\d+-aspnetruntime\"\s+version\=\"[^"]+\"' = 'id="{0}-aspnetruntime" version="{1}"' -f (Get-DotNetPackagePrefix -Version $Latest.ReleaseVersion -IncludeMajorMinor), $Latest.DepAspNet
            'id\=\"dotnet-aspnetcoremodule-v2\"\s+version\=\"[^"]+\"' = 'id="dotnet-aspnetcoremodule-v2" version="{0}"' -f $Latest.DepAncm
        }
    }
}

function global:au_GetLatest {
    $chunks = $Latest.PackageName -split '-'
    $rtBase = Get-DotNetRuntimeComponentUpdateInfo -Channel $chunks[1] -Component 'Runtime' -AllVersions:$AllVersionsAsStreams
    $rtAsp = Get-DotNetRuntimeComponentUpdateInfo -Channel $chunks[1] -Component 'AspNetRuntime' -AllVersions:$AllVersionsAsStreams
    $ancm = Get-DotNetRuntimeComponentUpdateInfo -Channel $chunks[1] -Component 'AspNetCoreModuleV2' -AllVersions:$AllVersionsAsStreams
    if ($AllVersionsAsStreams)
    {
        $aspLookup = @{}
        $rtAsp | ForEach-Object { $aspLookup[$_.ReleaseVersion] = $_ }
        $ancmLookup = @{}
        $ancm | ForEach-Object { $ancmLookup[$_.ReleaseVersion] = $_ }
        $result = @{
            Streams = [ordered]@{
            }
        }

        foreach ($thisRtBase in $rtBase)
        {
            $thisRtAsp = $aspLookup[$thisRtBase.ReleaseVersion]
            if ($null -eq $thisRtAsp)
            {
                Write-Warning "Missing ASP.NET Runtime for release $($thisRtBase.ReleaseVersion), skipping release"
                continue
            }

            $thisAncm = $ancmLookup[$thisRtBase.ReleaseVersion]
            if ($null -eq $thisAncm)
            {
                Write-Warning "Missing ASP.NET Core Module for release $($thisRtBase.ReleaseVersion), skipping release"
                continue
            }

            $thisInfo = @{
                Version = $thisRtBase.Version
                ReleaseVersion = $thisRtBase.ReleaseVersion
                ReleaseNotes = $thisRtBase.ReleaseNotes
                DepBase = Get-DotNetDependencyVersionRange -Boundary Patch -BaseVersion $thisRtBase.Version
                DepAspNet = Get-DotNetDependencyVersionRange -Boundary Patch -BaseVersion $thisRtAsp.Version
                DepAncm = Get-DotNetDependencyVersionRange -Boundary Patch -BaseVersion $thisAncm.Version
            }

            $result.Streams.Add($thisRtBase.ReleaseVersion, $thisInfo)
        }
    }
    else
    {
        $result = @{
            Version = $rtBase.Version
            ReleaseVersion = $rtBase.ReleaseVersion
            ReleaseNotes = $rtBase.ReleaseNotes
            DepBase = Get-DotNetDependencyVersionRange -Boundary Patch -BaseVersion $rtBase.Version
            DepAspNet = Get-DotNetDependencyVersionRange -Boundary Patch -BaseVersion $rtAsp.Version
            DepAncm = Get-DotNetDependencyVersionRange -Boundary Patch -BaseVersion $ancm.Version
        }
    }

    return $result
}

if ($MyInvocation.InvocationName -ne '.') { update -ChecksumFor none }
