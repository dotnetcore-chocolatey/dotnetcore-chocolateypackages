
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/c0aa84bb-3da1-4bce-9434-7036e94ae4b2/6d4fb01377f1f1eebb0997289dc8ecfb/dotnet-sdk-2.1.403-win-x86.exe'
$checksum   = 'c35be7071348b2812ee3694276b0bf7b9289f9176896b6d27ef0ab8d6c3f499e2678856d50b782a171c819e1837de070a4d9cb6897e05be86ed57cb97feda686'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/45f93081-cdb4-41c1-8d8d-e6c3bbf2872b/62d6a598956fdfe585acb1f15268d930/dotnet-sdk-2.1.403-win-x64.exe'
$checksum64 = '3630dc9c52ec6b08c0804da3fc9177d3d61f12f5629c65249f7bc75b34a24c4059812fc8e6cdef64dcc7c4030ad5952e998674ac1ef497f20e43b2ab4b53be90'

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
