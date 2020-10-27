$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2

$data = & (Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Path) -ChildPath data.ps1)

$arguments = @{
    packageName = $data.PackageName
    silentArgs = "$($data.AdditionalArgumentsToInstaller) /install /quiet /norestart /log ""${Env:TEMP}\$($data.PackageName).log"""
    validExitCodes = @(
        0, # success
        3010 # success, restart required
    )
    url = $data.Url
    checksum = $data.Checksum
    checksumType = $data.ChecksumType
}
$arguments64 = @{
    url64 = $data.Url64
    checksum64 = $data.Checksum64
    checksumType64 = $data.ChecksumType64
}

Set-StrictMode -Off
Install-ChocolateyPackage @arguments @arguments64
