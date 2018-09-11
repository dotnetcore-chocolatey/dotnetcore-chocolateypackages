
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.microsoft.com/download/8/A/7/8A765126-50CA-4C6F-890B-19AE47961E4B/dotnet-sdk-2.1.402-win-x86.exe'
$checksum   = 'b80459549cff5e93e5c1701fa1c852124fb22fde4dc513fef46d19d9c503e17e2567c04593551cc0dc9a6f573add5b6e0e3a7eed10998dd82a95b3e10a903505'
$url64      = 'https://download.microsoft.com/download/8/A/7/8A765126-50CA-4C6F-890B-19AE47961E4B/dotnet-sdk-2.1.402-win-x64.exe'
$checksum64 = '1020bd17cb6587f73125f36428bd945b720ba612037f58d7bb33751b90783f6e26090e125cd1421439c167a309fb62d2c480b8ee8e9e40dee1bf33dbe0fd5d0d'

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
