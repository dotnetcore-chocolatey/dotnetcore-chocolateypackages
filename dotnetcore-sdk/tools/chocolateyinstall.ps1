
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/b39635bf-e274-4be0-b35c-a6f92875756c/805a41e904d14b70c3d64a416f5bf12f/dotnet-sdk-5.0.100-rc.2.20479.15-win-x86.exe'
$checksum   = 'fd635f153c6bb4b1a4ed4839f50775dd3f4ec44dc6c3483b9640b1e2ae61c85051d52fcf774d815cb35260b35e11403ba7399520e6eda61442b64c16e4e9715b'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/3121f13a-c4a7-4a93-bf87-f66f6a8b182d/f85dafe84e9d57d9f9c5c4e6a29d04db/dotnet-sdk-5.0.100-rc.2.20479.15-win-x64.exe'
$checksum64 = 'c9668250d1bd1017d1d847e380bd28eaa6b967cc952c1933e8978e9fbeaaf9b9edc24d48cb932296a8c1749999345b07d8167ab1430930732921c896ca2dc27f'

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
