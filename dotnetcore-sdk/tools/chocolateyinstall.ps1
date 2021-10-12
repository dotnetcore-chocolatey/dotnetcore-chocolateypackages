
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/4298a151-4622-4e47-9f5b-e5b9a6ebd705/0b2967a7bc9faed2f8f6231b29c2b4be/dotnet-sdk-3.1.414-win-x86.exe'
$checksum   = '026d77004e9299a0e0c7673998ef207ce8bfc8dac5e7bf19c6f303e786cd7004e0efcb67e5db43daeace27524202ff1d3ae5384e3bcad8ae6ada2f8d4a95794e'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/89a2a9ff-0cff-493c-badd-112cd7d62576/bc233fa29900c6c3c280f4d1ba1240f4/dotnet-sdk-3.1.414-win-x64.exe'
$checksum64 = 'acc18e2f3114cf28da1076d5a1c8ec707dc80d88a9d4ae4811d909541607118fffdf7430263f59c3916f2716300f35a34cf4824c51b94d53777efee964110b20'

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
