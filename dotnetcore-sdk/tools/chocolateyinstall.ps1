
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/349bc444-2bf8-4aa0-b546-4f1731f499c5/64f6c5eb26fcd64fbdaee852f038cdd7/dotnet-sdk-3.1.404-win-x86.exe'
$checksum   = 'fbc027f54221df2f6b8ce86338994df9544aa419d4713fb588ccc29e13f8c7c2c5ca5ea8b3032837bbb3c33d8150cbfc2ee0267510834386a5782de84ed91d4c'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/3366b2e6-ed46-48ae-bf7b-f5804f6ee4c9/186f681ff967b509c6c9ad31d3d343da/dotnet-sdk-3.1.404-win-x64.exe'
$checksum64 = '9d12890913ec5e0d6894f769bb704673a8e15619ef19d0d1906a19f80be53f6ccbbf3f451e069676a1512755e1cd4fc4ee36becb9aa67e3c8edbce76fc854ddf'

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
