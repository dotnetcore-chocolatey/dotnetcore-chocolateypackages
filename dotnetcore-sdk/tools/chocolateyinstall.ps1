
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/e849877c-fd37-4a7f-9b53-50b1424d9d0e/66ab464f677a02ee2f8b0fe6159e06b2/dotnet-sdk-2.2.204-win-x86.exe'
$checksum   = '8D4CFCDC4BD391DC7E4DEE344E2BABDE283329936BD8565ABA9937C96E71D1ABCF7B8C9E3A57DB11A3739099A256705B337B45B80F6C20D9BCD1D3EA10FFEAC0'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/e50ce3cf-d86a-4f23-8e75-0d86f6d1eea8/1c0b05791a5b730927664828e002d2c1/dotnet-sdk-2.2.204-win-x64.exe'
$checksum64 = 'D538788C3FB19033F28874B4B19546EEF61F6E802B9FD15E07302568A80E25A125B265C00A439C45F82C77474CCBAA14623BE22D35A1CCE42D5F019FA202646A'

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
