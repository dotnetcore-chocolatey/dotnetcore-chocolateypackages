
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/74913ce9-27d6-4170-9a1b-0ec460b57b9c/dbed5e61d4e4c930b69775b15171c455/dotnet-sdk-3.1.410-win-x86.exe'
$checksum   = '8eb811750fb104a685ec1018906bc2bb4bdffc643f9812cf3ffad86d5336d7ff1f4bab33ae25e35e9a6f8fce97d65bace6a9c011a5b8c4d5ca78fd33f05ed9eb'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/d0a958a1-50e7-4887-ba3d-3b80e946d7a1/f247ffeae9d13f4ffcc731c7d7b3de45/dotnet-sdk-3.1.410-win-x64.exe'
$checksum64 = 'a300792bf831172e72ca26603129477e84af226591b9e9dba9d3d0198a3556bdabd924ec2a2df9a4b3e1a4a7f9f836c72731965d73cbd00c9ef0639830876e69'

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
