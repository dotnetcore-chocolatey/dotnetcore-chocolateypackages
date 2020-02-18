
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/0f19219f-3f53-4235-ba67-0bb74f3b1a23/0047614c923d2641344d8a3531efc5f5/dotnet-sdk-3.1.102-win-x86.exe'
$checksum   = '763ff189d55497accbdfb4b8745a9b76c92b17e99ec4a2e99c07e2f49ba8b3ad69b43135098cdce2a350cbe7b8bb91173af58f938074a1962afa558b399a3861'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/5aad9c2c-7bb6-45b1-97e7-98f12cb5b63b/6f6d7944c81b043bdb9a7241529a5504/dotnet-sdk-3.1.102-win-x64.exe'
$checksum64 = '361c805703812e1463e7660de99e569f476ea9164fd4267f314ce10b865321ba44d5afc3eaaed7c8617f7787845d08bcfbc2d3914441a16d47c87c88a1404390'

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
