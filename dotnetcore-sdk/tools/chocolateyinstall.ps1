﻿
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/34eb90cf-8de6-4301-9e61-5462b30edf4f/a493989fc106a5a851447ba6b7289ad6/dotnet-sdk-2.1.818-win-x86.exe'
$checksum   = '6f65a05178ac3abf65942bbc91c34784d496e822d69407fc33cd5519ede21ee09ebb5cc91a57dc928abd9c00e9580bf217d6bee2c400436e4625fc852d855f9e'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/fdc2c572-1f7f-4d46-b767-dd0951d10865/ad32c09fbef96146ec6b763d0192fba7/dotnet-sdk-2.1.818-win-x64.exe'
$checksum64 = 'f37af0f1ed01e665866b20a175b4305a5753aa6feb56da57184d06daf7dd51127d41e91f91cd11da23445010513ab20d974d21fb601d0234b5a314d3e3a6169f'

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
