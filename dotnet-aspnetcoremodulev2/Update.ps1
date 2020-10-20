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
            "[^\s]+\s+Release\s+Notes\]\([^)]+" = '{0} Release Notes]({1}' -f $Latest.ReleaseVersion, $Latest.ReleaseNotes
        }
    }
}

function global:au_GetLatest {
    @{
        Streams = [ordered] @{
            '5.0' = Get-DotNetRuntimeComponentUpdateInfo -Component 'AspNetCoreModuleV2' -Channel '5.0'
            '3.1' = Get-DotNetRuntimeComponentUpdateInfo -Component 'AspNetCoreModuleV2' -Channel '3.1'
            '3.0' = Get-DotNetRuntimeComponentUpdateInfo -Component 'AspNetCoreModuleV2' -Channel '3.0'
            '2.2' = Get-DotNetRuntimeComponentUpdateInfo -Component 'AspNetCoreModuleV2' -Channel '2.2'
        }
    }
}

if ($MyInvocation.InvocationName -ne '.') { update -ChecksumFor none }
