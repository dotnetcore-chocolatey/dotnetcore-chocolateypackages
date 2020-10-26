Import-Module au
Import-Module "$PSScriptRoot\..\tools\PSModules\DotNetPackageTools\DotNetPackageTools.psm1"

function global:au_SearchReplace {
    @{
        "$PSScriptRoot\$($Latest.PackageName).nuspec" = @{
            '\[.+Release\s+Notes\]\([^)]+\)' = '[{0} Release Notes]({1})' -f (Get-DotNetReleaseDescription -ReleaseVersion $Latest.ReleaseVersion), $Latest.ReleaseNotes
            'id\=\"dotnet\w*-\d+\.\d+-runtime\"\s+version\=\"[^"]+\"' = 'id="{0}-runtime" version="{1}"' -f (Get-DotNetPackagePrefix -Version $Latest.ReleaseVersion -IncludeMajorMinor), $Latest.DepBase
            'id\=\"dotnet\w*-\d+\.\d+-aspnetruntime\"\s+version\=\"[^"]+\"' = 'id="{0}-aspnetruntime" version="{1}"' -f (Get-DotNetPackagePrefix -Version $Latest.ReleaseVersion -IncludeMajorMinor), $Latest.DepAspNet
            'id\=\"dotnet-aspnetcoremodule-v1\"\s+version\=\"[^"]+\"' = 'id="dotnet-aspnetcoremodule-v1" version="{0}"' -f $Latest.DepAncm
        }
    }
}

function global:au_GetLatest {
    $chunks = $Latest.PackageName -split '-'
    $rtBase = Get-DotNetRuntimeComponentUpdateInfo -Channel $chunks[1] -Component 'Runtime'
    $rtAsp = Get-DotNetRuntimeComponentUpdateInfo -Channel $chunks[1] -Component 'AspNetRuntime'
    $ancm = Get-DotNetRuntimeComponentUpdateInfo -Channel $chunks[1] -Component 'AspNetCoreModuleV1'
    @{
        Version = $rtBase.Version
        ReleaseVersion = $rtBase.ReleaseVersion
        ReleaseNotes = $rtBase.ReleaseNotes
        DepBase = Get-DotNetDependencyVersionRange -Boundary Patch -BaseVersion $rtBase.Version
        DepAspNet = Get-DotNetDependencyVersionRange -Boundary Patch -BaseVersion $rtAsp.Version
        DepAncm = Get-DotNetDependencyVersionRange -Boundary Patch -BaseVersion $ancm.Version
    }
}

if ($MyInvocation.InvocationName -ne '.') { update -ChecksumFor none }
