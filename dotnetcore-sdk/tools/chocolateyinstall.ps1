
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/16378a9f-1291-4c34-8625-ab4dfebfb74a/096945940a346e326368c070b8ecc050/dotnet-sdk-3.0.100-win-x86.exe'
$checksum   = 'd5223e9526eadff3d80047ccc8d32c569b0eeed8372460f93d489544696bd6b4f053e5ab93730da4b4031f3d4d4b1c19f1ce30da6e7c1305b4dfea0ff91312d4'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/53f250a1-318f-4350-8bda-3c6e49f40e76/e8cbbd98b08edd6222125268166cfc43/dotnet-sdk-3.0.100-win-x64.exe'
$checksum64 = '2b353ca10cd5865a996ac707a8d548dc300e3676383e35930dfab97a16863a8d8e2056d4ecc3b863d10ff22b9e7cd0a874e016f45d77f9c5a02e5e7e821e6a7d'

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
