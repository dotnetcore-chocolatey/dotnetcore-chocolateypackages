$ErrorActionPreference = 'Stop';
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Microsoft .NET Core SDK *'
  fileType      = 'EXE'
  silentArgs    = "/uninstall /quiet"
  validExitCodes= @(0, 3010, 1605, 1614, 1641)
}

$uninstalled = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName'] | 
    ?{ -Not $_.WindowsInstaller -eq 1 } # for some reason the SDK is registered twice but picking the EXE instead of MSI here

$key | % { 
  $file = $_.UninstallString -replace '(?<=".+")\s+.*$', ''
  Write-Output "File: $file"
  $packageArgs['file'] = $file

  Uninstall-ChocolateyPackage @packageArgs
}