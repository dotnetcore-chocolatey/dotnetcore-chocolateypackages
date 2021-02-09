
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/e691a113-14dc-4a55-a6af-da5591db01dc/37c182ecc5b36334664d7c1052b7238f/dotnet-sdk-3.1.406-win-x86.exe'
$checksum   = '1467a070b6473ac794399a330c1dad34c8a7d3fa213641069383779bcfbfd5999f5d7c508a67d5657d2eda9b0199ef59645efa312e44a1235823c0d2fff6b674'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/cc28204e-58d7-4f2e-9539-aad3e71945d9/d4da77c35a04346cc08b0cacbc6611d5/dotnet-sdk-3.1.406-win-x64.exe'
$checksum64 = '6afc1916bd7be1488768ece0cc83c77d9962404f431331a7998a98385407dc7085fc04ccac2eeea1e28d38fdf870af71f61762e7d7b15c3a7ba56b6d6399d354'

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
