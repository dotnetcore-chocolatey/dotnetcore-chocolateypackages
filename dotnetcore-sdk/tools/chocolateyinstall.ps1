
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/d5821095-b8e2-47fd-b6a0-815beeefb0d4/f9b8a167f7e389b5e0207ada20caa1e9/dotnet-sdk-3.1.408-win-x86.exe'
$checksum   = '526edc3e2025459af340a6992f48625e41c4a6d4bdf75d7929c9de635bccfdd571d9deba0ddaec2235365131d0d1d1507178d53c82385f15cc360dfa51a94809'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/fa20039c-5871-4597-8a7b-f0553a12edcc/4fb1cce6214049fe639dd230a9265133/dotnet-sdk-3.1.408-win-x64.exe'
$checksum64 = 'c8d3000f07735ee7cdf3bab402323bf96413d7afd7dadc5f1e92f02c184b67ca00f188e083f1d6bd8ae21b88a24f87d443088ecee28c33cd186f8ca9606fc816'

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
