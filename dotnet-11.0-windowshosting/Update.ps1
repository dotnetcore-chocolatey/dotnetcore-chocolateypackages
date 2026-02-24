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
            'id\=\"dotnet-aspnetcoremodule-v\d+\"\s+version\=\"[^"]+\"' = 'id="{0}" version="{1}"' -f $Latest.AncmId, $Latest.DepAncm
        }
    }
}

function global:au_GetLatest {
    $channel = ($Latest.PackageName -split '-')[1]
    switch ($channel)
    {
        '2.1' { $ancmName = 'AspNetCoreModuleV1'; $ancmId = 'dotnet-aspnetcoremodule-v1' }
        default { $ancmName = 'AspNetCoreModuleV2'; $ancmId = 'dotnet-aspnetcoremodule-v2' }
    }

    $rtBase = Get-DotNetRuntimeComponentUpdateInfo -Channel $channel -Component 'Runtime' -AllVersions:$AllVersionsAsStreams
    $rtAsp = Get-DotNetRuntimeComponentUpdateInfo -Channel $channel -Component 'AspNetRuntime' -AllVersions:$AllVersionsAsStreams
    $ancm = Get-DotNetRuntimeComponentUpdateInfo -Channel $channel -Component $ancmName -AllVersions:$AllVersionsAsStreams
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
                AncmId = $ancmId
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
            AncmId = $ancmId
        }
    }

    return $result
}

if ($MyInvocation.InvocationName -ne '.') { update -ChecksumFor none -NoCheckUrl }
