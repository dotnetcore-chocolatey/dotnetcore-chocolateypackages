
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/9182f8b1-0b48-45da-ba29-ff2e06ad07ce/2c4a3dc1958867a54b1abe1a73ccbcac/dotnet-sdk-2.2.200-preview-009648-win-x86.exe'
$checksum   = '552528AF370039032C8A5AE17D55904DEBAA4523BD62C56E9946C0D0A84610DFB78271BA4575C34E92FC8F1A985CCF62FC85D51903FFFDABB80C3D336044D04D'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/8145cebd-ea45-4b3d-b13a-9f37c7be0588/00b4a7ed7952412edcaee68e181d72c4/dotnet-sdk-2.2.200-preview-009648-win-x64.exe'
$checksum64 = 'ED41A4AABBE13117566AFB00F08C582E62833E40F755082E6BE8F135EF880A0586478A88148BE99EF6F4BA4D812E0C7C6833A12A3FDB1CA4DEE238EA58B8F091'

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
