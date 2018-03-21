
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.microsoft.com/download/1/2/E/12E2BC14-7A9F-4497-A351-02B7C2DDD599/dotnet-sdk-2.1.102-win-x86.exe'
$checksum   = '3850b7ed490d64599f7aa592ab1cc59609c77f5f131e04c81cdc47b884db521b4ff421c25730907694b6107573c0fbc38765f6417b0ad5a1bbbd915765d8d617'
$url64      = 'https://download.microsoft.com/download/1/2/E/12E2BC14-7A9F-4497-A351-02B7C2DDD599/dotnet-sdk-2.1.102-win-x64.exe'
$checksum64 = 'ee698f7a3d88d22c344f3bf692a671c03abed634250a58c55de7eba33135df6d26315bf75caf8de5dd614900e51b3f602a07a0acbcee9ecc22ba9e323c5d0cdb'

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
