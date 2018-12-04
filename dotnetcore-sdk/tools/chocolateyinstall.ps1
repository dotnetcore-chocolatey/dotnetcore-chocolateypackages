
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/c7aecc9d-e8d0-451b-a5ed-de3095459883/9fcfdce401be67e0e53eee337e6c82c4/dotnet-sdk-2.2.100-win-x86.exe'
$checksum   = 'F961FB0197FDF0EBE345D34BC25B9FAAC3804E60DA8A2AA7E0C859951CF64E05913F302779CD0FF1AD49582F925EC11FAAA27E83C21AD656B8EE87900CBC923D'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/7ae62589-2bc1-412d-a653-5336cff54194/b573c4b135280fb369e671a8f477163a/dotnet-sdk-2.2.100-win-x64.exe'
$checksum64 = 'CDA96523F5969B8A338FFB89A14972F2D8B5697E60B7BC48BE70E019BB70BEEBF4EAAE2F3E84E0F9A90040EBDBA4E781D525CF7B41B95D44DAABD6A862129F7C'

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
