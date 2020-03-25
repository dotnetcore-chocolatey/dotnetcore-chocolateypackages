
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/c4e63d92-e9a4-4c45-a7f7-2e0cb8702e09/88c17c079c2c0da0af3a3545021a6cf3/dotnet-sdk-3.1.201-win-x86.exe'
$checksum   = '3fe714903d42a3bdff13a9151e5f2b5e4d5c6b254d59401e42dccb22fd085cb78d9dd477d2e236b14d5285a866f3140bbaa419b52f859d4c59800c4e47ca2906'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/56131147-65ea-47d6-a945-b0296c86e510/44b43b7cb27d55081e650b9a4188a419/dotnet-sdk-3.1.201-win-x64.exe'
$checksum64 = '893dc5f04f58f23b8b84ede4f7a4e9510de5cef277f28b768ca8bed05be024445e07029a79aec0ade3fd3741f1fd9f9b90c65ee992ba3d6238ac5649c9c8ce35'

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
