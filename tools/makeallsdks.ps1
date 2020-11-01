$global:au_NoCheckChocoVersion = $true
try
{
    Get-ChildItem -Path .\dotnet*-*-sdk* -Directory | ForEach-Object {
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
