
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/c98b5604-4aee-41e1-a13f-bd8fd1f2f70d/b0eeeb0a71586800f0057227aed3ed38/dotnet-sdk-2.2.100-preview3-009430-win-x86.exe'
$checksum   = '3f36656317627d46fbeebd4b45b62dcc11bed1303ae9090d9ce9db7f04c97ffa724f440eff88766e76a8c56e4530128723f450387c47df6ec9a815caa55b8b89'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/4539bc8d-3184-44ca-9303-013a9fc39a13/239d7eb8fb8b2d1e97744821413aaaee/dotnet-sdk-2.2.100-preview3-009430-win-x64.exe'
$checksum64 = 'b702cb920cb615b56da5b34ceb938e2f6b6130d954bb9e7906cf767c4b94275f0a2e99331bdfb77e1dc4e5a9e4a4e153ecb9a5559c8b0c91fd4c2d69c9a945a8'

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
