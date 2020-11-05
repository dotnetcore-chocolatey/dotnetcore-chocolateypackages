Import-Module au

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

function EntryToData($channel) {
    $url = "https://raw.githubusercontent.com/dotnet/core/master/release-notes/$channel/releases.json"
    $result = (Invoke-WebRequest -Uri $url -UseBasicParsing | ConvertFrom-Json)

    $latestRelease = $result."latest-release"
    $latest = $result.releases | ?{ $_.'release-version' -eq $latestRelease } | select -First 1

    $exe64 = $latest.'aspnetcore-runtime'.files | ?{ $_.name -like 'aspnetcore*x64.exe' }
    $exe32 = $latest.'aspnetcore-runtime'.files | ?{ $_.name -like 'aspnetcore*x86.exe' }

    if ([version]$channel -lt [version]'3.0' -or [version]$channel -ge [version]'5.0') {
        $version = $latest.'aspnetcore-runtime'.version
    } else {
        $version = $latestRelease #versioning scheme used in 3.x
    }

    @{ 
        Version = Get-Version -Version $version
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
             '3.1' = EntryToData -channel '3.1'
             '3.0' = EntryToData -channel '3.0'
             '2.2' = EntryToData -channel '2.2'
             '2.1' = EntryToData -channel '2.1'
             '2.0' = EntryToData -channel '2.0'
        }
    }
}

update -ChecksumFor none