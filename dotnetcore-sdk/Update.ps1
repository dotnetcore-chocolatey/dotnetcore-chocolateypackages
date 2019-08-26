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

function EntryToData() {
    param($channel, $version) 
    $url = "https://raw.githubusercontent.com/dotnet/core/master/release-notes/$channel/releases.json"
    $result = (Invoke-WebRequest -Uri $url -UseBasicParsing | ConvertFrom-Json)

    if (-Not($version)) {
        $version = $result."latest-sdk"
    }

    # try sdks array first
    $latest = $result.releases.sdks | Where-Object { $_.version -like $version } | Select-Object -First 1

    if ($latest) {
        $exe64 = $latest.files | Where-Object { $_.name -like '*win-x64.exe' }
        $exe32 = $latest.files | Where-Object { $_.name -like '*win-x86.exe' }
        $latestVersion = $latest.version
    } else {
        $latest = $result.releases | Where-Object { $_.sdk.version -like $version } | Select-Object -First 1

        $exe64 = $latest.sdk.files | Where-Object { $_.name -like '*win-x64.exe' }
        $exe32 = $latest.sdk.files | Where-Object { $_.name -like '*win-x86.exe' }
        $latestVersion = $latest.sdk.version
    }

    @{ 
        Version = $latestVersion;
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
             '3.0' = EntryToData -channel '3.0'
             '2.2' = EntryToData -channel '2.2'
             '2.2.1' = EntryToData -channel '2.2' -version '2.2.1??'
             '2.2.2' = EntryToData -channel '2.2' -version '2.2.2??'
             '2.2.3' = EntryToData -channel '2.2' -version '2.2.3??'
             '2.2.4' = EntryToData -channel '2.2' -version '2.2.4??'
             '2.1' = EntryToData -channel '2.1'
             '2.1.3' = EntryToData -channel '2.1' -version '2.1.3??'
             '2.1.4' = EntryToData -channel '2.1' -version '2.1.4??'
             '2.1.5' = EntryToData -channel '2.1' -version '2.1.5??'
             '2.1.6' = EntryToData -channel '2.1' -version '2.1.6??'
             '2.1.7' = EntryToData -channel '2.1' -version '2.1.7??'
             '2.1.8' = EntryToData -channel '2.1' -version '2.1.8??'
             '2.1.1' = EntryToData -channel '2.0' -version '2.1.1??' # 2.1.10x SDK is for 2.0
             '2.1.2' = EntryToData -channel '2.0' -version '2.1.2??' # 2.1.20x SDK is for 2.0
             '1.1' = EntryToData -channel '1.1'
        }
    }
}

update -ChecksumFor none