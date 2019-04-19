
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/e6cdbf31-8b69-4e30-b555-4d4543381c74/bde99c9c84d675e5462759a5d2586ce5/dotnet-sdk-3.0.100-preview4-011223-win-x86.exe'
$checksum   = '784C9621617745CAB5F986E386BAB2CD4E338D706CA06CBD82B4994F5722F8B4909166CE0120BC498F7EA4DB27A0423407F95029C00F21638949AAC1C86D7688'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/4032ceb5-61cd-495a-ab25-475aa2232f28/7eb614e777d87ef0d49f86be4fc8bbde/dotnet-sdk-3.0.100-preview4-011223-win-x64.exe'
$checksum64 = '13AE848788F1309CB49459823B23E435F0C79829BAB846B2AFEAA42099FB00DC7DA81CA442DF77C20E64DC2F5EDE9096F378279612771D972572857E5E8A2F2A'

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
