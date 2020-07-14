
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/e20f0ce6-9eb7-42ff-8a18-e2d9eb929b37/75677dea8ae7ccaec7a87d2de4b0a796/dotnet-sdk-3.1.302-win-x86.exe'
$checksum   = '98dd3291414c8eb8f9ba4b85481a6a4faca6c747bed734ab7d3246e810e0ac8ba5079d7212fae3add47aff22ad9286d00457871250d8b1bfeb129b1a861f3bf4'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/56b00a71-686f-4f27-9ad1-9b30308688ed/1fa023326e475813783a240532c9f2c8/dotnet-sdk-3.1.302-win-x64.exe'
$checksum64 = '56f25b43f4d3afc835c6145a048d6ad2077fa706188bb2d783ae288a97205fe37c973e3de64e441de18c75b397b40bdbc86062856e5b234b3fc40d92740080b7'

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
