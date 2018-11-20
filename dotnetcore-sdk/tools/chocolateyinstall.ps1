
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/59613bc7-269f-4c39-a58a-46b35fe314c0/ddae846724f96c9886b319b8f825e475/dotnet-sdk-2.1.500-win-x86.exe'
$checksum   = 'E34065EA573598F4098A9D57A05243FB9EE58C7A8AA08A81E7F6248372BF850F4A69CD2558FE1BE98B267491FBAC5022657E67625595795F9FB9AB5BBF6F8B14'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/cd42f66a-2b6a-4a7a-9e69-0bb4eb5a83a1/0ce246546a0886349d9acf872f4e15a4/dotnet-sdk-2.1.500-win-x64.exe'
$checksum64 = 'A6EB777DF0F8581872EF34D9363EA0148A95314546507B879B648CA8AA051791DA59377CA3F1786F18D2831823F2A2A9B6D275C96572F0917C88FBEB18272C32'

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
