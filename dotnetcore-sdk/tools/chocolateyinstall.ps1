
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/43d2148c-72a9-4658-9bb4-0d759203f20e/3837b775171032f0c2214c99ea56f7f5/dotnet-sdk-3.1.409-win-x86.exe'
$checksum   = '2eaccd629785f278c38f109b4fc028913c410440d3f366aa793fbb287f44baa910744d72d7b204020cd15b68114af09f7af768858335b36205422114029c370d'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/d144f312-0922-4c92-a13f-9ffdf946525e/f5fd0de3cc3a88ba6bdb515e6e4dc41a/dotnet-sdk-3.1.409-win-x64.exe'
$checksum64 = '06be05d47367bb9089146af8f66a57f8fbb8959253d403a031fe99ebf7decc33939096e0df3227b1b6ddfd114126cd2da291e52f9bda66f2717df96c207bf02e'

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
