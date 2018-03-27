
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.microsoft.com/download/E/2/6/E266C257-F7AF-4E79-8EA2-DF26031C84E2/dotnet-sdk-2.1.103-win-x86.exe'
$checksum   = 'ba0f0f9519a6c5a3bcd8325034f466212797e820e7671b019eec199c8ab9ffb2f3543eb5594c76f2374459e5c0e175bc8604b67f7de3c7505959c4e209d6d835'
$url64      = 'https://download.microsoft.com/download/E/2/6/E266C257-F7AF-4E79-8EA2-DF26031C84E2/dotnet-sdk-2.1.103-win-x64.exe'
$checksum64 = '909f178a98e1742e965d005187a6121dda71c224d8bfd018b07d8ec66591cc19906825e674e9f012f422d21a2929e67b15ff79d4c1ab3e72602b5b27e9ad4cbd'

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
