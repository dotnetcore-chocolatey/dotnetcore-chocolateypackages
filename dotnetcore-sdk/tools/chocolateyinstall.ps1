
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/8362d64d-26d0-458b-b560-ca927fbd102b/c43ccfe2f8e1c640f994a33a16b98ef6/dotnet-sdk-3.1.100-preview3-014645-win-x86.exe'
$checksum   = 'dbc74246bf0c4f1aedf21fd6965a568feff159851696478b75abdb9d3d985efa456c7e6128ca477650ca707a7061f19ec07bdad0354ca02b0c74456529e2c593'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/90a377d2-5255-4bce-8612-a11dc81fe450/8587dee87b56f392f96695177972c418/dotnet-sdk-3.1.100-preview3-014645-win-x64.exe'
$checksum64 = 'f825fc838e6e4ed697ea3333d001620c24242f4f46061763d61ed6c4aaca630cfa727b9cc5dc2fca1c57c2157fabd6658b28a9ee39721fd86385a1bb5351056c'

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
