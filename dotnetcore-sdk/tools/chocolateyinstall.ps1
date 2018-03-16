
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.microsoft.com/download/D/C/F/DCFA73BE-93CE-4DA0-AB76-98972FD6E475/dotnet-sdk-2.1.101-win-x86.exe'
$checksum   = '22527e8d3ce51189707c411bf67a23d3745bd39f994b67d2a5004f3c143439d3583d7df3935b89f5a3d58ac5a51970c2ee61043897258d45c3fff74e95091fe0'
$url64      = 'https://download.microsoft.com/download/D/C/F/DCFA73BE-93CE-4DA0-AB76-98972FD6E475/dotnet-sdk-2.1.101-win-x64.exe'
$checksum64 = 'c7fb50ca82acba7e9454d53bf9c47a240611f731ea4a095957dfe58ab0404d4f98585951258fb353b5ff16a808dc89931f30b6b8a0ea6e1c967f2e84ba6ee101'

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
