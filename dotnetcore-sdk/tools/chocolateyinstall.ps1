
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.microsoft.com/download/3/7/1/37189942-C91D-46E9-907B-CF2B2DE584C7/dotnet-sdk-2.1.200-win-x86.exe'
$checksum   = '04ea62e1391820ee3289a6c622221908ac7336465d8cf6615228d6bfcab7e46419c3e6a826b27f41dd8ec629dc24aebf9af8ef85d0e6bf1fb8664ffff238d96f'
$url64      = 'https://download.microsoft.com/download/3/7/1/37189942-C91D-46E9-907B-CF2B2DE584C7/dotnet-sdk-2.1.200-win-x64.exe'
$checksum64 = '0bde9fbd2d5f1e3376e96a499056dd29d788ad98674ea5e6c683a66709293374b418f094d0ac17388b6435fdade61f276752155fe158df798c1213083b5e0ea9'

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
