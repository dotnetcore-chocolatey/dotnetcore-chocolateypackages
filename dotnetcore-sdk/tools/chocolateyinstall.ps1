
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/583ccd29-41c9-4121-907b-d96d38a655a7/e6ad854e859b8eabdca6c2352881cb45/dotnet-sdk-2.1.814-win-x86.exe'
$checksum   = '3cce057824063598eba71734563a7b20e42fd575e6215d99606fc342d6cb4beeb27b8578ed9818bea9b6c95772cb3ee218ca13421f8047fc8bda6d4b6cb41fea'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/c1fd12ab-c597-4cea-8272-874d260447c7/6499d1534178ed0e0abb6451b67133dd/dotnet-sdk-2.1.814-win-x64.exe'
$checksum64 = 'dba99d5d8f75876f0cdc0260f86d7ba6caeab64aafebe5d0f087aaf4e9696f0f9cedc3dcd25102c490bdedf88f31f0d14238bade4d39b3ebfd808d90b8d6db27'

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
