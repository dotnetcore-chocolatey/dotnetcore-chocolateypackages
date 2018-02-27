
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.microsoft.com/download/D/7/8/D788D3CD-44C4-487D-829B-413E914FB1C3/dotnet-sdk-2.1.300-preview1-008174-win-x86.exe'
$checksum   = 'bd8a9145f651026cfa1ca7c264c2e05b3740afc0b5f8ac5572409a95836d8f87e1a8c460eb985182501f679b721a97fd174b7690ab8cdc5e43c8155ee8af94b5'
$url64      = 'https://download.microsoft.com/download/D/7/8/D788D3CD-44C4-487D-829B-413E914FB1C3/dotnet-sdk-2.1.300-preview1-008174-win-x64.exe'
$checksum64 = 'd6749ef041136865353289250a92fae582c118f77b2838ceb9484854b636249bc2950da942bd807bd3ec04f91bc2b9ccf0bc73a9771c04e8552db82d56eb73ee'

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

















