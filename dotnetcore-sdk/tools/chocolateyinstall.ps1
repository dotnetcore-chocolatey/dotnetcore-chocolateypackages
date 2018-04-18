
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.microsoft.com/download/2/E/C/2EC018A0-A0FC-40A2-849D-AA692F68349E/dotnet-sdk-2.1.105-win-x86.exe'
$checksum   = 'a06393e1030e88f39628e070c6743745d142c754f0a604d26f33a35a5635ad6622f2994db719fa566352c1d0dc1f97a58dcf2792e80e6529359ae1e5454ee2a6'
$url64      = 'https://download.microsoft.com/download/2/E/C/2EC018A0-A0FC-40A2-849D-AA692F68349E/dotnet-sdk-2.1.105-win-x64.exe'
$checksum64 = '35b64e8fc1ed63778880790fcb59d2e92176e1673753b5b9c9c1e0eb1b87353eb940453abdff51457467f98a0c49a574feff1301536410ba036dc3d63affd439'

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
