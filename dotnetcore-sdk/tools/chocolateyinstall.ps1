
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/e7e10509-f1ec-4d5c-9fe9-33a2d5a8fac0/dcf905cdac05719a5a5fa1ee1c365c4e/dotnet-sdk-3.0.100-preview7-012821-win-x86.exe'
$checksum   = '98D71FD29875C645FF07C5DB9B4BD5985C96F282CCDD8C47DAC59A88B8571CE30BFAA8E6AA13640D53515D35FADEA02AB8565E083C807496EEC150C5F05ECBCA'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/a65e3536-ad76-4808-9920-83702aeed082/3c6ab9eaa0bc99df442be91e7b7950ff/dotnet-sdk-3.0.100-preview7-012821-win-x64.exe'
$checksum64 = '3A94FA4CB71072E401697F3D6601AD01997D814079862B9AC4A2DB12288C603D5EB91E6523F9C443F10CA753C5FA9182E1D355FD097A736D43E8EACBAB05DE52'

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
