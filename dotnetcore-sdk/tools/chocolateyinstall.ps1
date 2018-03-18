
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.microsoft.com/download/6/5/F/65F1653E-F835-4DE3-BB36-F324D3925F32/dotnet-dev-win-x86.1.1.8.exe'
$checksum   = '8cc35987ea38aba18ab314fd41bbe5eaa3a07e97e81e69c15de4fb49efd7d3abc61901da27c6ca4bea1bde1a6ead512ddf64c89599797653dddb73041f508ee0'
$url64      = 'https://download.microsoft.com/download/6/5/F/65F1653E-F835-4DE3-BB36-F324D3925F32/dotnet-dev-win-x64.1.1.8.exe'
$checksum64 = '278304c8ef455e3c0d24d5b9dc3c2d0019b1a429d968e4a39f499b8e63636685ef6cfef38a50b954fa24189c3421f9a3d157a0113064af09bc55f66f391a0b8f'

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
