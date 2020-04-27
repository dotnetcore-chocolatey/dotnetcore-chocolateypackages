Import-Module au

$releases = "https://raw.githubusercontent.com/dotnet/core/master/release-notes/releases.json"

function global:au_SearchReplace {
    @{
        "tools\data.ps1" = @{
            "(^\s*Url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"           #1
            "(^\s*Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"      #2
            "(^\s*Url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"           #1
            "(^\s*Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"      #2
            "(^\s*Version\s*=\s*)('.*')" = "`$1'$($Latest.Version)'"      #2
        }
    }
}

function EntryToData($channel) {
    $url = "https://raw.githubusercontent.com/dotnet/core/master/release-notes/$channel/releases.json"
    $result = (Invoke-WebRequest -Uri $url -UseBasicParsing | ConvertFrom-Json)

    $version = $result."latest-runtime"
    $latest = $result.releases | ?{ $_.runtime.version -eq $version } | select -First 1
    
    $exe64 = $latest.runtime.files | ?{ $_.name -like 'dotnet*win-x64.zip' }
    $exe32 = $latest.runtime.files | ?{ $_.name -like 'dotnet*win-x86.zip' }

    @{ 
        Version = Get-Version($version);
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
             '5.0' = EntryToData('5.0')
             '3.1' = EntryToData('3.1')
             '3.0' = EntryToData('3.0')
             '2.2' = EntryToData('2.2')
             '2.1' = EntryToData('2.1')
             '2.0' = EntryToData('2.0')
             '1.1' = EntryToData('1.1')
             '1.0' = EntryToData('1.0')
        }
    }
}

if ($MyInvocation.InvocationName -ne '.') { update -ChecksumFor none }
