
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/cf521b5e-c9f2-4f28-aac5-0404f2f4183c/65c9d9038013e4efdb772fa5ba6127f9/dotnet-sdk-3.1.405-win-x86.exe'
$checksum   = 'fbd30e77f15535fd3db4e2aceb95d0f15d378d25a900f050c5e35c0b65e6e11173f1411407a0e193be126ba2a7bb6518b4acefcab659171ebfc9b94bbf2a7349'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/c5cf65f5-85ca-4ae0-9c36-a0e0a852c218/07b9418c61804efb0fb079c28b1b1c90/dotnet-sdk-3.1.405-win-x64.exe'
$checksum64 = '6dd2f4f45036c25918d8fd48fde7109b1c794d4c2f863131b02f0b5b30d6fbeba070bbbadc897f672c098ec34baf26db33d6a99e19b72eb450cdfb4dc9c445d0'

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
