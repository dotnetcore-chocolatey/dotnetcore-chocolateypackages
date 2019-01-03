
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/caa1967f-4459-40a0-9703-cd7c4330be6a/722e7928c1bbebf2b174f5293c97328f/dotnet-sdk-2.1.502-win-x86.exe'
$checksum   = 'F4969D01F05ECA28B545B335E221DA6DA07A3B087A4B91BE0153494ECD483DB943178BBFB8EA1C8D032C07F0C1F50F801CCEF1542F3B09016E760E0D1CE8B277'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/70b3a142-06fa-4d86-b1cc-67a48c1eaacb/55e147bd47db930a642a8f8176949a76/dotnet-sdk-2.1.502-win-x64.exe'
$checksum64 = '20E5D2E54CCAD8CE2C5EED0EFFCBA5D610C8BF1D15F8D2EE2E792547B35697EA408A415D2F580E0E2F693339E5E10F0A46B82B88171016378AFBBA4BF4A55227'

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
