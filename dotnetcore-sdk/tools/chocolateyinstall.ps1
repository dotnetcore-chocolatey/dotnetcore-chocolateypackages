
$ErrorActionPreference = 'Stop';

$packageName= 'dotnetcore-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.visualstudio.microsoft.com/download/pr/f6fb21ca-cbf8-41a0-87b9-84225ae485cd/7dcd7ed94e6614098edd2f9832bceeee/dotnet-sdk-3.1.100-win-x86.exe'
$checksum   = '73c7bb7faecbae179c6967f06ccaf4b31fab61d4a190e150af5bef71c5eafc3f0aecdb3c2c04ed90ba5aef8468bae0f0fafac3eaf9facd4cca3586972632ce2c'
$url64      = 'https://download.visualstudio.microsoft.com/download/pr/639f7cfa-84f8-48e8-b6c9-82634314e28f/8eb04e1b5f34df0c840c1bffa363c101/dotnet-sdk-3.1.100-win-x64.exe'
$checksum64 = '4b73d5cc6cd1c98700749548acb8b3c6edc2ad0ceee7d9034766b434c5c70897d15a626e295788483f36f858ebd60f7ceb806380fca3a38138ab35db8fd867cf'

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
