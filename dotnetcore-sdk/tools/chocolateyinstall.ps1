
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/54e11f2e-481c-4923-8f72-68f9f5a39dc6/0557eb054165b0c00e655ed6f2f67bb9/dotnet-sdk-3.1.202-win-x86.exe'
$checksum   = '1f7f1ce1d196d45a9ffe02b4a2bb39cb75419ef61fb0a0db0fb67b0d75c86589a6650621c1663e1df4211ecc57cf52bdd542312b3426de2048aa2ef12ca3b3d4'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/f222bff9-8f0a-4720-b9db-7f80c31c6561/5d522c84f2715df94f7a988d8ab547b8/dotnet-sdk-3.1.202-win-x64.exe'
$checksum64 = '272b60e92809b7182258594fcbe059c4a3281113d9ab41235343250553219788158b743f3695e829f5846d424c59b323bf977ade64a9a9785c1c0fc4a6baf11a'

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
