
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/5e75f564-99d0-4052-b9cc-0f99c332c850/635ea4277999f68d409f645ad45163ef/dotnet-sdk-2.2.202-win-x86.exe'
$checksum   = 'EE7369D7E3608DB07A8D8619D859FE63E479795BCB087F0DACFDA3DCDF9B2AB922496766718316240DAEA10E779BEFA6BC45396CB2C6F3489B6C390CBF08A47F'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/aab60233-b80b-472d-8cf4-1384074f0f03/eb24a5dd5e3f506c893655e582d34a86/dotnet-sdk-2.2.202-win-x64.exe'
$checksum64 = '0CECEAC51CCE75FD61344EBA77D35467321D11A803F24D303EE73E45463E0C06C252E882E720EA4848A0BCB0C3B1205313A2DBFB50313791A412E502B40FFB5E'

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
