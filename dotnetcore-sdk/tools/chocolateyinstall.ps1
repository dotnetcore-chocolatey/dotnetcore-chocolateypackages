
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.microsoft.com/download/9/D/2/9D2354BE-778B-42D6-BA4F-3CEF489A4FDE/dotnet-sdk-2.1.400-win-x86.exe'
$checksum   = 'ef7e6e2c9478f64f42deb3969fb09e485ff9951fc425de94cc66e78de83f6e33bbd15a4d5e28043d681c808ce38e9b3cb2adb784c77f9657e5c375280bed46b6'
$url64      = 'https://download.microsoft.com/download/9/D/2/9D2354BE-778B-42D6-BA4F-3CEF489A4FDE/dotnet-sdk-2.1.400-win-x64.exe'
$checksum64 = '23d64045822763213453b6354728026c300ab36018da27e5f18aef6ab3956c625e8b63c9a39eed1b16bdd14d76b8b99c659bc741ff1d667c8338cb5c86399bdd'

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
