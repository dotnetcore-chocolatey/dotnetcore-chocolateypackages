
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.microsoft.com/download/4/0/9/40920432-3302-47a8-b13c-bbc4848ad114/dotnet-sdk-2.1.302-win-x86.exe'
$checksum   = '19239e9a54117baf7a3a1ffd56b4ec5b3e5b9e40f2ead3a70c549cf742f415cf3b65176d3e2c3b2d2668f6851c3dfa50bb178ba9af7bb36404a0620da2518519'
$url64      = 'https://download.microsoft.com/download/4/0/9/40920432-3302-47a8-b13c-bbc4848ad114/dotnet-sdk-2.1.302-win-x64.exe'
$checksum64 = '30cd9f690f20c435f30430dff5901c778fd708e9ceab85d7a7bacd469524a7c027e9e5dbb951ec0bc8f7cf9bbd88df225159c87b581ff2cbb0fbc241917fc7aa'

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
