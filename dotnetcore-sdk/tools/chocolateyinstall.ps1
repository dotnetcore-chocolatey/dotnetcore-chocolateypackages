
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/6e841eb8-1330-4f18-b0b0-89694f7f88c1/135a47cf13838a49b275c336c0b697fb/dotnet-sdk-3.1.411-win-x86.exe'
$checksum   = 'ec122326f17c811b55f486b5d36696506f4eb56f13602bb1c163a5fddc2dc1593d60ca990a84cc65711e20a354adcb2718fa0e163634564944ecf518f7cc5c6b'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/17d4e08f-c93a-4e2c-83e6-1e7010b5c7ad/53fc30104eb36c45f6ef5930e4c88c01/dotnet-sdk-3.1.411-win-x64.exe'
$checksum64 = '79b2726f425c2d0bc4dffc05e65ec3f8a70e526b59671ec2bddaaaef598a72b461b0344e736775a3fa2541a4b175adeb7709487828f30b2f9e777e17076f4bf4'

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
