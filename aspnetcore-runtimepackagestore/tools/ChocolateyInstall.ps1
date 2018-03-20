$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2

$data = & (Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Path) -ChildPath data.ps1)

function Test-Skip32BitRequested
{
    return $Env:chocolateyPackageParameters -like '*Skip32Bit*'
}

function Test-QuietRequested
{
    return $Env:chocolateyPackageParameters -like '*Quiet*'
}

function Test-OsSupports32Bit
{
    $getWindowsFeature = Get-Command -Name 'Get-WindowsFeature' -Module 'ServerManager' -ErrorAction 'SilentlyContinue'
    if ($getWindowsFeature -eq $null) {
        Write-Debug 'Get-WindowsFeature command not found, assuming client/legacy OS and 32-bit support always present'
        return $true
    }
    $wow64 = Get-WindowsFeature -Name 'WoW64-Support' -ErrorAction 'SilentlyContinue'
    if ($wow64 -eq $null) {
        Write-Debug 'WoW64-Support feature not found, assuming legacy OS and 32-bit support always present'
        return $true
    }
    Write-Debug "WoW64-Support feature is installed: $($wow64.Installed)"
    return $wow64.Installed
}

function Get-PassiveOrQuietArgument
{
    [CmdletBinding()]
    Param (
        [string] $Scenario = 'installation'
    )
    if (Test-QuietRequested) {
        Write-Verbose "Performing a quiet $Scenario, as requested."
        $passiveOrQuiet = 'quiet'
    } else {
        Write-Verbose "Performing an $Scenario with visible progress window (default)."
        $passiveOrQuiet = 'passive'
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
        }
    } else {
        Write-Host 'Installation of 32-bit version will be skipped, as requested by package parameters.'
    }
}

$passiveOrQuiet = Get-PassiveOrQuietArgument -Scenario 'installation'
$arguments = @{
    packageName = $data.PackageName
    silentArgs = "$($data.AdditionalArgumentsToInstaller) /install /$passiveOrQuiet /norestart /log ""${Env:TEMP}\$($data.PackageName).log"""
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
