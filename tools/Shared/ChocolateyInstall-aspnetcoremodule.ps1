$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2

$data = & (Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Path) -ChildPath data.ps1)

function Get-DismPath
{
    # .NET Core supports Windows 7 or later - this aligns nicely with dism.exe availability
    $dism = Join-Path -Path $Env:SystemRoot -ChildPath 'System32\dism.exe'
    if (-not (Test-Path -Path $dism)) {
        throw 'Windows 7 / Server 2008 R2 or later is required.'
    }
    return $dism
}

function Test-IisInstalled
{
    $dism = Get-DismPath
    $iisState = 'Unknown'
    & $dism /English /Online /Get-FeatureInfo /FeatureName:IIS-WebServer | Tee-Object -Variable dismOutput | Select-String -Pattern '^State : (\w+)$' | ForEach-Object { $iisState = $_.Matches[0].Groups[1].Value }
    if ($LastExitCode -ne 0) {
        Write-Warning "Unable to determine IIS installation state (dism.exe exit code: $LastExitCode)"
        Write-Warning 'dism.exe output:'
        $dismOutput | Write-Warning
    } else {
        Write-Debug 'dism.exe output:'
        $dismOutput | Write-Debug
    }
    $iisInstalled = $iisState -eq 'Enabled'
    return $iisInstalled
}

function Ensure-IisInstalled
{
    $iisInstalled = Test-IisInstalled

    if (-not $iisInstalled) {
        $ignoreMissingIisKeyword = 'IgnoreMissingIIS'
        if ($Env:chocolateyPackageParameters -notlike "*$ignoreMissingIisKeyword*") {
            throw "IIS is not installed. Install at least one of IIS components, such as IIS-StaticContent, before installing this package, or pass '$ignoreMissingIisKeyword' as package parameter to force the installation anyway."
        } else {
            Write-Warning "IIS is not installed, but proceeding with the installation because '$ignoreMissingIisKeyword' was passed as package parameter."
        }
    }

    if ($iisInstalled) {
        Write-Verbose 'IIS is enabled.'
    } else {
        Write-Warning 'IIS is not enabled. The ASP.NET Core Module for IIS requires IIS to be enabled before installing the module. To install the module, enable IIS and install this package again using the --force switch.'
    }
}

function Test-PassiveRequested
{
    return $Env:chocolateyPackageParameters -like '*Passive*'
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

Ensure-IisInstalled

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
    url64 = $data.Url64
    checksum64 = $data.Checksum64
    checksumType64 = $data.ChecksumType64
}

Set-StrictMode -Off
Install-ChocolateyPackage @arguments
