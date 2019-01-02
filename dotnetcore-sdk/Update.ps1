Import-Module au

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

function EntryToData($channel) {
    $url = "https://raw.githubusercontent.com/dotnet/core/master/release-notes/$channel/releases.json"
    $result = (Invoke-WebRequest -Uri $url -UseBasicParsing | ConvertFrom-Json)

    $version = $result."latest-sdk"
    $latest = $result.releases | ?{ $_.sdk.version -eq $version } | select -First 1

    $exe64 = $latest.sdk.files | ?{ $_.name -like '*win-x64.exe' }
    $exe32 = $latest.sdk.files | ?{ $_.name -like '*win-x86.exe' }

    @{ 
        Version = $version;
        URL32 = $exe32.url;
        URL64 = $exe64.url;
        ChecksumType32 = 'sha512';
        ChecksumType64 = 'sha512'; 
        Checksum32 = $exe32.hash;
        Checksum64 = $exe64.hash;
    }
}

function global:au_GetLatest {
      @{
         Streams = [ordered] @{
             '2.2' = EntryToData('2.2')
             '2.1' = EntryToData('2.1')
             '1.1' = EntryToData('1.1')
        }
    }
}

update -ChecksumFor none