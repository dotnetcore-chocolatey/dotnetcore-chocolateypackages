


$ErrorActionPreference = 'Stop';
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Microsoft .NET Core SDK*'
  fileType      = 'EXE'
  silentArgs    = "/uninstall /quiet"
  validExitCodes= @(0, 3010, 1605, 1614, 1641)
}

$uninstalled = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName'] | 
    ?{ -Not $_.WindowsInstaller -eq 1 } # for some reason the SDK is registered twice but picking the EXE instead of MSI here

if ($key.Count -eq 1) {
  $key | % { 
    $file = $_.UninstallString -replace '(?<=".+")\s+.*$', ''
    Write-Output "File: $file"
    $packageArgs['file'] = $file

    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
}


