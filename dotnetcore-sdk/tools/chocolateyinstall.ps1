
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/719cf74a-8a57-405d-a048-be8d94bbef37/1914f811ddbf10f7a2a45181b9cac714/dotnet-sdk-3.1.401-win-x86.exe'
$checksum   = '367815d46a2d5efcd850caa061fd706bdc8e10d8c9b920d5e0a7d6cb700af1e42c4301fb5cf54c1fefde8e9e89f80a22791e4819d0b04f781d9ac3c04292c6af'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/547f9f81-599a-4b58-9322-d1d158385df6/ebe3e02fd54c29487ac32409cb20d352/dotnet-sdk-3.1.401-win-x64.exe'
$checksum64 = 'd14cb0bd419e009ec4aefd06e33066c5ba0a7640c9f4b40a619fb766e8c1b33fe812f290169a029ecb991d47b6b7d777a8cb57016932c103c8f749ff6222e893'

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
