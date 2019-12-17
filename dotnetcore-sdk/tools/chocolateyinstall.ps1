
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/1af1c7ed-74dc-4772-8e8c-146e54a47b2f/162c9a7e45ea5080a3f4085d8684b7b9/dotnet-sdk-2.2.110-win-x86.exe'
$checksum   = '365de8c85f22977d3fda98fe02d15fc3c847b43ce1b447fb9028c062a86c541fd668a48d50633b1ce8e3469b7d219ac68cff33d8b3b064325c66d021d30f4b3e'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/78969d24-673f-4515-9544-1dd5bcda5411/beda84891a9a085cecd9bff855fdd082/dotnet-sdk-2.2.110-win-x64.exe'
$checksum64 = 'd36edc2cc36e3f1a673cfddc4c5ccfd70806f56604995015678e17ab3ece7cc5a530b4f1dbb9e03f916c5cd0eabd13005219c25259d29528cb4efc3a03425623'

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
