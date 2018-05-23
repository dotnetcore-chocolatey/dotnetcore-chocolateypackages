Import-Module au

$releases = "https://raw.githubusercontent.com/dotnet/core/master/release-notes/releases.json"

function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"           #1
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"      #2
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"           #1
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"      #2

        }
    }
}

function EntryToData($info) {
    $version = $info.'version-sdk'
     $url32   = $info.'dlc-sdk' + @($info.'sdk-win-x86.exe', [IO.Path]::ChangeExtension($info.'sdk-win-x86', 'exe') -ne $null)[0]
     $url64   = $info.'dlc-sdk' + @($info.'sdk-win-x64.exe', [IO.Path]::ChangeExtension($info.'sdk-win-x64', 'exe') -ne $null)[0]

     @{ Version = $version; URL32 = $url32; URL64 = $url64; ChecksumType32 = 'sha512'; ChecksumType64 = 'sha512'; }
}

function global:au_GetLatest {
     $json = (Invoke-WebRequest -Uri $releases -UseBasicParsing | ConvertFrom-Json)

      @{
         Streams = [ordered] @{
             '2.1-preview' = EntryToData($json | where { $_.'version-sdk' -match '^2.1.\d+-.*$' } | sort { [datetime]$_.'date' } -Descending | select -First 1)
             '2.1' = EntryToData($json | where { $_.'version-sdk' -match '^2.1.\d+$' } | sort { $_.'version-sdk' -as [version] } -Descending | select -First 1)
             '1.1' = EntryToData($json | where { $_.'version-sdk' -match '^1.1.\d+$' } | sort { $_.'version-sdk' -as [version] } -Descending | select -First 1)
        }
    }
}

update