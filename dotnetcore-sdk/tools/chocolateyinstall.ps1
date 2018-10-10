
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/9386d3bc-6799-4cc5-8288-c807674c72ed/b585db316f0d1c4cad749c247ef21b59/dotnet-dev-win-x86.1.1.11.exe'
$checksum   = '88778c12aa4e3bdb696da31d5ae1a03441fc6d0d1860bada75bc604692e3f8c240941a10b8a99eaace2b5a6957bcdafa158f2cfb533d122bffcb2c55b25f351d'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/baf5a5a7-68d6-4cf1-afdf-47968b5f91e7/05e6dfe191607ef6135a34215464f600/dotnet-dev-win-x64.1.1.11.exe'
$checksum64 = '6e15fa8c9d5b10cc3edb353c5e1ece01a29f7d00ff853cc12f84e33a776df8062c07febbd9659ca46c2adeb005036c231fd7a7592591b6e28c643bdc45084778'

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
