
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/aa0057ee-f80e-48a3-b3c6-86caa4317827/0cd1eb1081972f6f11394163542e07a3/dotnet-sdk-2.2.105-win-x86.exe'
$checksum   = 'F64653A6C3EC0CA298E849C2CAB2538BF3643DDDDE276AF512BAF5C3CA8A9E40A8C3FFEC30FC88A846E941B2DC49B61346A28C6DC42B26F735052A591A3651E9'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/8148cce0-196d-4634-86df-f3d4550b1a75/89ed68d0ecf6b1c62cc7b0d129fdf600/dotnet-sdk-2.2.105-win-x64.exe'
$checksum64 = '0F71DE050A106EC9FB4AE6057BC77387E3BA62485F47DD586E5FB119FB547C6C54C8E2F511D4E1EA8D5B420494C17F85F1BE8C4A48FDC85CBCFE93EE9D51A1A9'

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
