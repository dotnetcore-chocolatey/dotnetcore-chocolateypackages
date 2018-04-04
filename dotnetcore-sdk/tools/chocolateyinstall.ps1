
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.microsoft.com/download/D/8/1/D8131218-F121-4E13-8C5F-39B09A36E406/dotnet-sdk-2.1.104-win-x86.exe'
$checksum   = '4462a33130b09ba6b9d5f8b579b91ff797f4081717ccc4ecde507bfd2c774985e73458716b6b1f3ea714b020d0607d99c9a013629497c26e89b3424e1713ab97'
$url64      = 'https://download.microsoft.com/download/D/8/1/D8131218-F121-4E13-8C5F-39B09A36E406/dotnet-sdk-2.1.104-win-x64.exe'
$checksum64 = '90402af6694fe7fd5af65b25afd94538133d3f15fa52cf2c8bc86c7b8d32f8ec347788e0d69b51026d1927f3c734ffc6e0bf87380846a37676a7f6dcd97798f7'

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
