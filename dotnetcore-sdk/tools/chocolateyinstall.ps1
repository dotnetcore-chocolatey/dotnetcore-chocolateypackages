
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/40d62e77-4049-4500-9bdb-bfcad7ade5a6/a26e70ec74e41554d4a20df907b20e55/dotnet-sdk-2.2.402-win-x86.exe'
$checksum   = 'D783F027158D06A364F8A0992336FEFE39BA1DE4752E07B81B7FFF9B3966C065B8BE09088E0E050BAC6D388BDFC6F42F8D88303F2ECDF6FFAD7F52D759114CB4'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/40c1dd82-671c-4974-919d-ac8a61ef5a91/49ab67c335878f4a5bdd84e14c76708f/dotnet-sdk-2.2.402-win-x64.exe'
$checksum64 = '45C43A28A702DF5C1C534A66ED216842B04CA2936932F116FCFD88CE41DD49317C7518B7AAEF2360C758FC86528A8B00CE13116518B9CE6765202DE747D0D38B'

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
