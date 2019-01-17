
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/a47b3710-f1c9-41ea-a826-23923a3344e8/608c60965f54fc20048a4b6840e513f1/dotnet-sdk-2.2.103-win-x86.exe'
$checksum   = 'A6EE0C079BA02AEE1A75179E3420D08486C0AB0D101B27E22F889D9A9E83A97BA6AAADD4F2221ADCF6DAA9E9B74CF5ED41B3DCA0B1F34F44405814F72FFDB8B3'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/c509efa5-f867-48e0-a231-625849a192a5/55dff1e29ba23a8b8e08c10d243c854e/dotnet-sdk-2.2.103-win-x64.exe'
$checksum64 = '2D42517E8C716E59A01C77D94C76F718916190B5A9A9318D17985AFDF34E1335997C7502AB1CFC43955BD8B8AD543BD554475BDAECC5F900F37AAE066F1423B1'

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
