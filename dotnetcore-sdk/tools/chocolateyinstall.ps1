
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/81b8367d-dd8f-4fa3-b0b0-b921195b1c38/8e16c1f687cd85d3825438500e29f2df/dotnet-sdk-3.1.402-win-x86.exe'
$checksum   = '7e7cafb8bc81b7bf83f160e2745e079496b6aa36f51c5c4161db296e3c898b1b2b66442e455c595f7e4d19630e39b1c11a766ff473431884831aafb3858a9c08'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/9706378b-f244-48a6-8cec-68a19a8b1678/1f90fd18eb892cbb0bf75d9cff377ccb/dotnet-sdk-3.1.402-win-x64.exe'
$checksum64 = '1c933d0bab8896e41fc92640c859b18ad8debf5a61d17a0b484d24dc1edfb24640393d17435321f983e2cd7d9e2fc4fc9f679bf6821ffc2fc0602803499c6169'

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
