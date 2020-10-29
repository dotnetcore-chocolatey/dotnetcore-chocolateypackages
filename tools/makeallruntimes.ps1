$global:au_NoCheckChocoVersion = $true
try
{
    $paths = @(
        '.\dotnet*-*-aspnetruntime'
        '.\dotnet*-*-desktopruntime'
        '.\dotnet*-*-runtime'
        '.\aspnetcore*-*-runtimepackagestore'
        #'.\dotnet*-*-windowshosting' # not ready yet
        #'.\dotnet-aspnetcoremodule-*' # not ready yet
    )
    Get-ChildItem -Path $paths -Directory | ForEach-Object {
        Push-Location $_
        .\update.ps1 -AllVersionsAsStreams
        Pop-Location
    }
}
finally
{
    Remove-Variable -Name au_NoCheckChocoVersion -Scope Global
    Write-Warning "Do not add the generated json files to git!"
}
