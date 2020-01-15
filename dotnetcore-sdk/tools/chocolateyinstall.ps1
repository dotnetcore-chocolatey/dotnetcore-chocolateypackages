
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/31b790f6-8557-48d9-bb57-9b2900ead284/4072f3d932af91e2a3127e552370c2b4/dotnet-sdk-3.1.101-win-x86.exe'
$checksum   = '71fef05e26f1c07c368ccb399f27bf3cd02d099b2e83456ae173c5fe1e6b945286c44897d9c8977d72f0614db65d097a291285e8bbb3b738e24f66354d2f8e6a'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/854ca330-4414-4141-9be8-5da3c4be8d04/3792eafd60099b3050313f2edfd31805/dotnet-sdk-3.1.101-win-x64.exe'
$checksum64 = 'eec02a5434de65b36b481136db06cd10eba4ca5c4947b536d567b003a8cac4f29012b74ad131a1e0dd4a79611702aa660f57949f0761259d1050d2481e4929cd'

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
