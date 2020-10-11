
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/ad6d35ac-f597-42d8-b0c4-48d685b94a33/bea99eb7c4e031191a9a88a50835a34b/dotnet-sdk-5.0.100-rc.1.20452.10-win-x86.exe'
$checksum   = '6e44fd1ecc91b568f625f85107157ee75d7d9db5a1489e7d18e40be9251ad27ca48345505bd4c0c58c41a9dc67e6b7c9d5bc5e0d46ad8d9ade14adf847c40dc7'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/fc1e9923-c4ea-41eb-bddb-165b684fdd4d/cdc2508795eef111e2feb35625e2e460/dotnet-sdk-5.0.100-rc.1.20452.10-win-x64.exe'
$checksum64 = '5631F81D9F06D0199FD32F3C98467DBB4AE59F6160C3EFA6B2BF572509F4178BE50DB9557BA89BD234758F01CF38A26BEF85D24D03E36B0571C47A4394E2EE4F'

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
