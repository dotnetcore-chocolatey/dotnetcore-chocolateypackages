
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/9c48244e-b292-4d16-9c19-5d10f734ab73/e288faa1ec2facfeda91f0614995ff9c/dotnet-sdk-2.2.107-win-x86.exe'
$checksum   = 'AB8ED818B3DDCD049BABBA89590B8FD7E1BDA7691546D704205BA937FBEF0A9556536A660799251DF11FA26C6B11B94411CBF8CA75DC6CBE84540DF60E966AB5'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/fb931b49-7f40-44ba-a347-f0b9fe655864/c99d8ab0402d4b8e6831e1ee74aa945b/dotnet-sdk-2.2.107-win-x64.exe'
$checksum64 = '56A1B2F7B334F12DF1B3BBA5E771C65872702A596249DDFC7DCE2449028CC65F968B6F5CA785E67EE20C3430A19463FF7223057C9591A84744CCD3EF5D5AC2C6'

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
