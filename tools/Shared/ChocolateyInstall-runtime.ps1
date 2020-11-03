$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2

$data = & (Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Path) -ChildPath data.ps1)

function Test-Skip32BitRequested
{
    return $Env:chocolateyPackageParameters -like '*Skip32Bit*'
}

function Test-PassiveRequested
{
    return $Env:chocolateyPackageParameters -like '*Passive*'
}

function Test-OsSupports32Bit
{
    $cmdGetWindowsOptionalFeature = Get-Command -Name 'Get-WindowsOptionalFeature' -ErrorAction 'SilentlyContinue'
    if ($null -eq $cmdGetWindowsOptionalFeature) {
        Write-Debug 'Get-WindowsOptionalFeature command not found, assuming legacy OS and 32-bit support always present'
        return $true
    }
    $wow64 = Get-WindowsOptionalFeature -Online -FeatureName 'ServerCore-WOW64' -ErrorAction 'SilentlyContinue'
    if ($null -eq $wow64) {
        Write-Debug 'ServerCore-WOW64 feature not found, assuming client or legacy server OS and 32-bit support always present'
        return $true
    }
    Write-Debug "ServerCore-WOW64 feature state is: $($wow64.State)"
    return ($wow64.State -eq 'Enabled')
}

function Get-PassiveOrQuietArgument
{
    [CmdletBinding()]
    Param (
        [string] $Scenario = 'installation'
    )
    if (Test-PassiveRequested) {
        Write-Verbose "Performing an $Scenario with visible progress window, as requested."
        $passiveOrQuiet = 'passive'
    } else {
        Write-Verbose "Performing a quiet $Scenario (default)."
        $passiveOrQuiet = 'quiet'
    }
    return $passiveOrQuiet
}

$shouldInstall32Bit = $false
if (Get-ProcessorBits -eq 64) {
    if (-not (Test-Skip32BitRequested)) {
        if (Test-OsSupports32Bit) {
            $shouldInstall32Bit = $true
        } else {
            Write-Host 'Installation of 32-bit version will be skipped because the WOW64 subsystem is not installed.'
            Write-Warning 'Because of a limitation of the .NET Core installer, even the 64-bit version will probably fail to install (https://github.com/dotnet/runtime/issues/3087).'
        }
    } else {
        Write-Host 'Installation of 32-bit version will be skipped, as requested by package parameters.'
    }
}

$passiveOrQuiet = Get-PassiveOrQuietArgument -Scenario 'installation'
$arguments = @{
    packageName = $data.PackageName
    silentArgs = "$($data.AdditionalArgumentsToInstaller) /install /$passiveOrQuiet /norestart /log ""${Env:TEMP}\$($data.PackageName)-$(Get-Date -Format 'yyyyMMddHHmmss').log"""
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
if ($shouldInstall32Bit) {
    Install-ChocolateyPackage @arguments
}
