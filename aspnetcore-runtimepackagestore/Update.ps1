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

function EntryToData($version) {
    $url = "https://raw.githubusercontent.com/dotnet/core/master/release-notes/$version/releases.json"
    $result = (Invoke-WebRequest -Uri $url -UseBasicParsing | ConvertFrom-Json)

    $latest = $result.releases | select -First 1
    $exe64 = $latest.'aspnetcore-runtime'.files | ?{ $_.name -like 'aspnetcore*x64.exe' }
    $exe32 = $latest.'aspnetcore-runtime'.files | ?{ $_.name -like 'aspnetcore*x86.exe' }

    @{ 
        Version = $latest.'aspnetcore-runtime'.version;
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
             '2.0' = EntryToData('2.0')
        }
    }
}

update -ChecksumFor none