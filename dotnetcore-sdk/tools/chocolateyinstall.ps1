
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/c2a9c458-284b-479e-b1ea-0fc70b3b54e6/d65071f4140136ecfe825dcd31fa9f92/dotnet-sdk-3.1.407-win-x86.exe'
$checksum   = '337e5d3cf7a5b3beb828755f4f4efb0c96e60b521bbd1bac3b12ed05575324e3c090973a3197ed14d66a852106fbf1817acb42879c9063049bd229641e0416a6'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/a45c8c1c-6466-4afc-a266-bd540069a4a6/97293f1080615bba5572ad1ef3be254c/dotnet-sdk-3.1.407-win-x64.exe'
$checksum64 = 'd80d05c292361ac464d2d231c649e18db7f30abddd9257087b47908ceb123cd9f702e65ca875ecdc359333f9ed2bdd5275a2f3431786b00c47afaef4579e1355'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  url64bit      = $url64

  silentArgs    = "/install /quiet /norestart /log `"$env:TEMP\$($packageName)\$($packageName).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)

  softwareName  = 'dotnet-core*'
  checksum      = $checksum
  checksumType  = 'SHA512'
  checksum64    = $checksum64
}

Install-ChocolateyPackage @packageArgs
