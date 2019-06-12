
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/4a6fef07-dc91-4fbd-87c8-74fd8db71aeb/9fa79398a69ac4bd08e8bf51080b3553/dotnet-sdk-3.0.100-preview6-012264-win-x86.exe'
$checksum   = '89E27B9A43EACE572883452565321F09B0104B25303083FA61A5A6BE464EC51705582CF281069F526E3FF7487208E8E6B0BC71FD6D8DEA32B617571435EA0A95'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/4d2dfaa1-4f9c-4526-bb6f-117d9d8bbd0e/a9fc9994c1b4d485ab41632b81bf4f56/dotnet-sdk-3.0.100-preview6-012264-win-x64.exe'
$checksum64 = 'D53279FD8D6D816E65C134F52C2211E27D6C5BBBD8A8AE9A1D7008CFD1A9143A97A033676B9CDB9B86CC1CF50F430D6BD5A7646250AD1DC4A18D3FCD75AD4D8B'

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
