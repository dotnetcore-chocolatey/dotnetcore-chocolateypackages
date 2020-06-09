
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/77b944fa-aa83-4101-85a9-9d3bde200ebc/f0f0e2a3544593b19df8471cbe9b6b61/dotnet-sdk-3.1.301-win-x86.exe'
$checksum   = '6c060c220b0282c88382a66f4569501c2fb803ded6c90481f1828715105e9ca2a9e31ed48eca6f1acc28b73b237fdaaf872c912f67703fb5aa7ecf9c15c8cf6d'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/4e88f517-196e-4b17-a40c-2692c689661d/eed3f5fca28262f764d8b650585a7278/dotnet-sdk-3.1.301-win-x64.exe'
$checksum64 = 'd4c564fb970f8f21ae7c1ae3185eb1f048d2ff79755198c25cfe461049c3a34de7392c8f4c66da2591b086ea69fb4d9caf830346ed98619743a201d05148ca16'

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
