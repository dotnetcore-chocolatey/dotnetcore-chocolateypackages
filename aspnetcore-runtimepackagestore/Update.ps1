. $PSScriptRoot\..\functions.ps1
Import-Module au

$releases = "https://raw.githubusercontent.com/dotnet/core/master/release-notes/releases.json"

function global:au_SearchReplace {
    @{
        "$PSScriptRoot\tools\data.ps1" = @{
            "(^\s*Url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"           #1
            "(^\s*Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"      #2
            "(^\s*Url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"           #1
            "(^\s*Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"      #2
        }
    }
}

function global:au_BeforeUpdate() {
    $Latest.Checksum32 = Get-RemoteChecksumFast -Url $Latest.Url32 -Algorithm 'sha512'
    $Latest.Checksum64 = Get-RemoteChecksumFast -Url $Latest.Url64 -Algorithm 'sha512'
}

function EntryToData($info) {
    $version = $info.'version-runtime'
    $url32   = $info.'dlc-runtime' + $info.'rps-win-x86.exe'
    $url64   = $info.'dlc-runtime' + $info.'rps-win-x64.exe'

     @{ Version = $version; URL32 = $url32; URL64 = $url64; ChecksumType32 = 'sha512'; ChecksumType64 = 'sha512' }
}

function global:au_GetLatest {
     $json = (Invoke-WebRequest -Uri $releases -UseBasicParsing | ConvertFrom-Json)

      @{
         Streams = [ordered] @{
             '2.1' = EntryToData ($json | where { $_.'version-runtime' -match '^2\.1\.\d+(-[a-zA-Z0-9]+)?$' } | sort { $_.'version-runtime' -as [version] } -Descending | select -First 1)
             '2.0' = EntryToData ($json | where { $_.'version-runtime' -match '^2\.0\.\d+(-[a-zA-Z0-9]+)?$' } | sort { $_.'version-runtime' -as [version] } -Descending | select -First 1)
        }
    }
}

if ($MyInvocation.InvocationName -ne '.') { update -ChecksumFor none }
