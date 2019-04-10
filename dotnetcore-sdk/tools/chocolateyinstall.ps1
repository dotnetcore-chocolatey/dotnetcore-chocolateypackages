
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/df174ab6-0fcd-47cd-bc95-6a0e09e8f71b/fc7101af6ac2cdac1e0a09075490fd45/dotnet-sdk-2.2.203-win-x86.exe'
$checksum   = '561EBD4546E5CB44D4414D29A085CDEFC60D60EAED1DA82C179860A3E5384BFA48961A709249C5572D1785E2CA123F020A6353F158EB095584978E1C933D3D6C'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/3c43f486-2799-4454-851c-fa7a9fb73633/673099a9fe6f1cac62dd68da37ddbc1a/dotnet-sdk-2.2.203-win-x64.exe'
$checksum64 = '8286860182B7AF6259AA9F28BD58A64B6EB92AFE3F8E6A9BC8DD15793F2A94DD06FABF60B22B9A786461F0BB27982B55184890C8409BC2BDDD5E3C1A02DDBB52'

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
