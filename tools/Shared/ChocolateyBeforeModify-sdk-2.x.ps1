$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2

$data = & (Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Path) -ChildPath data.ps1)

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    silentArgs     = "/uninstall /quiet"
    validExitCodes = @(0, 3010, 1605, 1614, 1641)
}

# the bitness info is at the end, e.g. "(x64)"
$softwareName  = "Microsoft .NET Core SDK $($data.SoftwareVersion) (*)"
[array]$keys = Get-UninstallRegistryKey -SoftwareName $softwareName `
    | Where-Object {
        # each SDK install has two entries, one "public", for the WiX Burn package, one hidden, for the underlying MSI
        # we need to use the "public" entry, which is what the user would see in Add/Remove Programs
        # https://docs.microsoft.com/en-us/windows/win32/msi/arpsystemcomponent
        -not $_.SystemComponent -eq 1
    }

# we may have two items here, one for x64, another for x86
$keys | ForEach-Object {
    # "C:\ProgramData\Package Cache\{c4615fd2-6841-49cb-bcd3-a2cd7bd74a85}\dotnet-sdk-2.0.0-win-x64.exe"  /uninstall
    # discard arguments (everyting after closing quote) and strip quotes
    $file = ($_.UninstallString -replace '(?<=".+")\s+.*$', '').Trim('"')
    Write-Verbose "Uninstalling using: $file"

    Uninstall-ChocolateyPackage @packageArgs -File $file
}
