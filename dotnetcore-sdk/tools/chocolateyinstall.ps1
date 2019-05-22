
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/0236fbc7-d78e-4800-b363-400f225b9ea8/04cca825769020ad3cdb96351ed6e0f1/dotnet-sdk-2.2.300-win-x86.exe'
$checksum   = 'DC2AC716B77CA69D6BD7BFF7DA27FD69CAAEFC2B9C2C13F4498B50214AFA894ED558773953672223CCA005A31E7E6CC0AD91D5F51E07BC153A1DC6237C5E411D'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/0d4f13a2-dd2f-4259-852e-58763d9ef303/cacb9821c492242072b0927dcb5808f5/dotnet-sdk-2.2.300-win-x64.exe'
$checksum64 = '4D1BF45DA628402FF1D5264999823A9248D81B0C78AE59648D3F32D0202FC36DFD823EA834AA9158ADFBD8335803E07C62183065AD7E518A16121D469DF94E02'

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
