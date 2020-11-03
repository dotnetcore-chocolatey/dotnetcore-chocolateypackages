$global:au_NoCheckChocoVersion = $true
try
{
    $paths = @(
        '.\dotnet'
        '.\dotnet-desktopruntime'
        '.\dotnet-runtime'
        '.\dotnet-sdk'
        '.\dotnet-windowshosting'
    )
    Get-Item -Path $paths | ForEach-Object {
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
