
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.microsoft.com/download/B/1/9/B19A2F87-F00F-420C-B4B9-A0BA4403F754/dotnet-sdk-2.1.300-rc1-008673-win-x86.exe'
$checksum   = '803c748bb67c77939232b36ddcc90b3663fd3679cf82aab0baba5979caf28252a2b171e2e3c69bd313a87e2ca78869bd484597170a2118c359fffa3dfb2a4470'
$url64      = 'https://download.microsoft.com/download/B/1/9/B19A2F87-F00F-420C-B4B9-A0BA4403F754/dotnet-sdk-2.1.300-rc1-008673-win-x64.exe'
$checksum64 = '7256aca2c02827028213ce06ceb5414231b01bbc509d0d57d5258106760c0fa5621a9d5f629fca3f34d6c45523a133206561d7188a0cb4817d4d5cc6c172d6f0'

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
