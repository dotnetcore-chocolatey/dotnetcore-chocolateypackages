. $PSScriptRoot\..\aspnetcore-runtimepackagestore\update.ps1

Rename-Item -Path Function:\au_GetLatest -NewName Get-RuntimePackageStoreLatest

$releases = "https://raw.githubusercontent.com/dotnet/core/master/release-notes/releases.json"
function global:au_SearchReplace {
    $replacements = @{
        "$PSScriptRoot\tools\data.ps1" = @{
            "(^\s*Url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"           #1
            "(^\s*Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"      #2
            "(^\s*Url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"           #1
            "(^\s*Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"      #2

        }
         "$PSScriptRoot\$($Latest.PackageName).nuspec" = @{
             "(\<dependency .+?""aspnetcore-runtimepackagestore"" version=)""([^""]+)""" = "`$1""[$($Latest.RpsVersion)]"""
         }
    }
    if ($Latest.RpsVersion -ne $null)
    {
        $replacements["$PSScriptRoot\$($Latest.PackageName).nuspec"] = @{
             "(\<dependency .+?""aspnetcore-runtimepackagestore"" version=)""([^""]+)""" = "`$1""[$($Latest.RpsVersion)]"""
        }
    }
    else
    {
        $replacements["$PSScriptRoot\$($Latest.PackageName).nuspec"] = @{
             "<dependency .+?""aspnetcore-runtimepackagestore""[^>]+>" = ''
        }
    }
    return $replacements
}

function global:au_BeforeUpdate() {
    $checksum = Get-RemoteChecksum -Url $Latest.Url32 -Algorithm 'sha512'
    $Latest.Checksum32 = $checksum
    $Latest.Checksum64 = $checksum
}

function EntryToData($info, $rpsVersion) {
    $version = $info.'version-runtime'
    $url32   = $info.'dlc-runtime' + $info.'hosting-win-x64.exe'
    $url64   = $info.'dlc-runtime' + $info.'hosting-win-x64.exe'

     @{ Version = $version; URL32 = $url32; URL64 = $url64; ChecksumType32 = 'sha512'; ChecksumType64 = 'sha512'; RpsVersion = $rpsVersion }
}

function global:au_GetLatest {
    $rpsLatest = Get-RuntimePackageStoreLatest
    $rpsLatest | Format-List -Property * | Out-String | Write-Debug

     $json = (Invoke-WebRequest -Uri $releases -UseBasicParsing | ConvertFrom-Json)

      @{
         Streams = [ordered] @{
             '2.1' = EntryToData ($json | where { $_.'version-runtime' -match '^2\.1\.\d+(-[a-zA-Z0-9]+)?$' } | sort { $_.'version-runtime' -as [version] } -Descending | select -First 1) $rpsLatest.Streams['2.1'].Version
             '2.0' = EntryToData ($json | where { $_.'version-runtime' -match '^2\.0\.\d+(-[a-zA-Z0-9]+)?$' } | sort { $_.'version-runtime' -as [version] } -Descending | select -First 1) $rpsLatest.Streams['2.0'].Version
             '1.1' = EntryToData ($json | where { $_.'version-runtime' -match '^1\.1\.\d+(-[a-zA-Z0-9]+)?$' } | sort { $_.'version-runtime' -as [version] } -Descending | select -First 1) $null
        }
    }
}

update -ChecksumFor none
