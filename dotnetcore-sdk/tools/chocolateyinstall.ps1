
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/012515a0-f0e4-43a1-87b4-23583adbead9/7002292a3866ea3262099a3de99fb9d0/dotnet-sdk-3.0.100-preview3-010431-win-x86.exe'
$checksum   = ''
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/31b5b67f-b787-4f73-a728-5ec61f10a4de/be6430bcd9a62f610cd9f12f8cc2c736/dotnet-sdk-3.0.100-preview3-010431-win-x64.exe'
$checksum64 = ''

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
