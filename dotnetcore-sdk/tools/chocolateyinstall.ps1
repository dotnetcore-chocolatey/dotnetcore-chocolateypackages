
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/cd02d3e6-ecc0-432d-a1bc-e8c9d3d8148c/f628e6721d33d13afe450abec8750f64/dotnet-sdk-2.2.104-win-x86.exe'
$checksum   = '2E903EFF30AF25115F452C8D00754955D33E77401455C19D43CFC53C1EC2052A40921F269F1706BECB091ABFE5D9B419BF46FFD91119FB5B85485A99B782DA6B'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/4a195fc9-7696-4c24-add2-e791b399766c/3a67d698a74505b46db9d9779745e47b/dotnet-sdk-2.2.104-win-x64.exe'
$checksum64 = '262E8921D678150B08B6E6563170BE2826C7D012AC6CCFA23D8686DFE3FBCD42CA5B24124631DBDFA497A609BD5700F736C7F43FF467629C0B4B20FA90F67F48'

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
