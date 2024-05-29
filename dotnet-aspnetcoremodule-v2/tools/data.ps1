@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://download.visualstudio.microsoft.com/download/pr/751d3fcd-72db-4da2-b8d0-709c19442225/33cc492bde704bfd6d70a2b9109005a0/dotnet-hosting-8.0.6-win.exe'
    Checksum = '01c4d06e0bb10e69581b67fba6618f003fdbdd6043bab4c58c47b7f8ac25e52ab7bd3e39404f733821fe6083e2462dbca20b2ff948a7abe8fbb4fd2f26956584'
    ChecksumType = 'sha512'
    Url64 = 'https://download.visualstudio.microsoft.com/download/pr/751d3fcd-72db-4da2-b8d0-709c19442225/33cc492bde704bfd6d70a2b9109005a0/dotnet-hosting-8.0.6-win.exe'
    Checksum64 = '01c4d06e0bb10e69581b67fba6618f003fdbdd6043bab4c58c47b7f8ac25e52ab7bd3e39404f733821fe6083e2462dbca20b2ff948a7abe8fbb4fd2f26956584'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
