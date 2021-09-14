
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/0ccbbe4c-a6cc-442d-b81d-26fdf0ad67e9/742749e5c907162356f5b9ab9edd8efa/dotnet-sdk-3.1.413-win-x86.exe'
$checksum   = '55c96e477c270b6d20c433da0dc95db3ac6c0c7efed3dbb7f37769a6da68a94aba7be82be445a511e28b927642d1e8e3d9657304a56a89366e8004599881925d'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/70062b11-491c-403c-91db-9d84462ee292/5db435e39128cbb608e76bf5111ab3dc/dotnet-sdk-3.1.413-win-x64.exe'
$checksum64 = '878ca8654df81a363c4cddddb5303857f3e21be684f191f5c9cff1505038e4303524890edd778892ea13b752ea112d9ecdbb3ada2fdd8439071e6160ce02b8d7'

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
