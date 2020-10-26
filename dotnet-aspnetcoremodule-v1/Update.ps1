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
    @{
        Streams = [ordered] @{
            # 2.0 and earlier releases.json does not provide ANCM version
            '2.1' = Get-DotNetRuntimeComponentUpdateInfo -Component 'AspNetCoreModuleV1' -Channel '2.1'
            '2.2' = Get-DotNetRuntimeComponentUpdateInfo -Component 'AspNetCoreModuleV1' -Channel '2.2'
        }
    }
}

if ($MyInvocation.InvocationName -ne '.') { update -ChecksumFor none }
