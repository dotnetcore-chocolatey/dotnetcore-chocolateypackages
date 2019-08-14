
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/20950cfc-c203-45ae-ba74-2d1c66178285/8426d962b1c4a2b3f8ae785d0d7aab2a/dotnet-sdk-3.0.100-preview8-013656-win-x86.exe'
$checksum   = '2D5A335F5C8775263A259B9F41D17905CD3FCA38558336CD294BBD30361157CFE7C252F4DC89215BDC92E602845FF253C1A9301AE0BF36C3196EBFD7DF3BF124'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/a46fa009-033b-430d-89a8-c9a107f73d87/d25f962e8212aafb3b0c426eb8cb4dc6/dotnet-sdk-3.0.100-preview8-013656-win-x64.exe'
$checksum64 = '02A59F2A07274B3331B804ACDC37E12047182B63BF2F82D96E1ABCB022B8596F9B441CAC025AD04123741AD00DAABEA7F6E12080A4FFD7E938B1752F9276FD6B'

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
