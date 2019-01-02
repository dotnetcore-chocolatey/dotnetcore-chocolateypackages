
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/ee6d9efe-1a5b-4fb2-af45-40b79d1ddfe6/6f3f1078dbe2bd5b1656a8ab14614205/dotnet-sdk-2.2.101-win-x86.exe'
$checksum   = '055B22D54C24A2B2A43C43DBF1516C0C2979F1B9718DE2B6EE0BCEC6DDE0512457DD66298F109A1C9E3E98F4FDAD8070BCE1B13F6F81653228A580C74D47BDAD'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/d4592a50-b583-434a-bcda-529e506a7e0d/b1fee3bb02e4d5b831bd6057af67a91b/dotnet-sdk-2.2.101-win-x64.exe'
$checksum64 = '9009CF8666DF060546915A777783DC1E69CFD645BFE9F0BB6F517070D36355EA22B7B4DF5EAE9AB0748013BBB6E41587C2F029B0922804BC3DD569654F329C88'

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
