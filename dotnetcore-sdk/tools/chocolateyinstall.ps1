
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/7755a8d6-cb7a-420d-97df-9ea738c4f837/3d50324180753bd6946b01dbe9b31b2f/dotnet-sdk-2.2.401-win-x86.exe'
$checksum   = '2AC8D34162F3A69251E09E1ED2126C76316153585FF8525E6117D031E908E24BE71B138E96529A7ED588DA6EE37CD625CEEFF971E8B10326C3C5A80051258B10'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/c76aa823-bbc7-4b21-9e29-ab24ceb14b2d/9de2e14be600ef7d5067c09ab8af5063/dotnet-sdk-2.2.401-win-x64.exe'
$checksum64 = 'D9308187C65E6B82E63777A2B9CF53FBEFAC8819A136375B4D40AB9DE95EB453A2F3C9133DFB4BF24C0C5C9E9D921ADFF842BA6951B9CB1BEBAE5B15CA41FDC0'

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
