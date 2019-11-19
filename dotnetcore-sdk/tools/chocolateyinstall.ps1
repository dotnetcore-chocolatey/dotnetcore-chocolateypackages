
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/9a8b141c-a157-48df-af71-4ce922ad7ee4/0d24f68cb8e404cff90d0e0a39d4b86e/dotnet-sdk-3.0.101-win-x86.exe'
$checksum   = 'ba25df49ce10fa7b75e2dcee600b489e52eb04668a3208682dfbc11bd26d9909a606641ddaa3470a431f9d31afdef17afdd3d2fc9b6119be9cc980c9e80ff374'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/66adfd75-9c1d-4e44-8d9c-cdc0cbc41104/5288b628601e30b0fa10d64fdaf64287/dotnet-sdk-3.0.101-win-x64.exe'
$checksum64 = 'cc0cac8e6850295f5a265d28bc21c5b22442823d996ad4742b3d93646b8846298bb393e1b9602c185c765ef4d29b9957eba5851cba4a5613c505c3980cf469ff'

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
