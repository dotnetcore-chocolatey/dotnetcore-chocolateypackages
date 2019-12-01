. $PSScriptRoot\..\dotnetcore-desktop-runtime\update.ps1

function global:au_SearchReplace {
   @{
        ".\$($Latest.PackageName).nuspec" = @{
            "(\<dependency .+?`"$($Latest.PackageName)-runtime`" version=)`"([^`"]+)`"" = "`$1`"[$($Latest.Version)]`""
        }
    }
}

update -ChecksumFor none