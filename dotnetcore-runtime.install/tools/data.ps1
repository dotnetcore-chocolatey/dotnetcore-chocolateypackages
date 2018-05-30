@{
    PackageName = 'dotnetcore-runtime.install'
    Version = '2.1.0'
    Url = 'https://download.microsoft.com/download/9/1/7/917308D9-6C92-4DA5-B4B1-B4A19451E2D2/dotnet-runtime-2.1.0-win-x86.exe'
    Checksum = '7894e33971fe6a56a9ee6cb628cdcc6a51c56bc9176abf4c61ca8f5180b33ed459615668fea6447856dbefe4473b182a7af2601c2bd7f3ee715663ddc24f2772'
    ChecksumType = 'sha512'
    Url64 = 'https://download.microsoft.com/download/9/1/7/917308D9-6C92-4DA5-B4B1-B4A19451E2D2/dotnet-runtime-2.1.0-win-x64.exe'
    Checksum64 = 'ec23c90c95d8501b05b87c42cdd189174f7c2ee8891196ee595f31e209e2670625e6b0b30d019cb09fbf4e3f17b20c9669ca63b5082cc6f8e547802eed9fffbc'
    ChecksumType64 = 'sha512'
    ApplicationName = "Microsoft .NET Core Runtime - $env:ChocolateyPackageVersion *"
    UninstallerName = 'dotnet-runtime-*.exe'
    AdditionalArgumentsToInstaller = $null
}
