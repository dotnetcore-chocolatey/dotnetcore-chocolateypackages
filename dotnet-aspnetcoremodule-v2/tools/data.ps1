@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://download.visualstudio.microsoft.com/download/pr/70f96ebd-54ce-4bb2-a90f-2fbfc8fd90c0/aa542f2f158cc6c9e63b4287e4618f0a/dotnet-hosting-8.0.5-win.exe'
    Checksum = 'cf3d170c977acd119cf3a261e88ac51de86f165fde01d4545951a145fbbecd62d9d6a6e2af3630065d982a14b264e10f5980c2de72ef3c6e49097dd4c18e03d0'
    ChecksumType = 'sha512'
    Url64 = 'https://download.visualstudio.microsoft.com/download/pr/70f96ebd-54ce-4bb2-a90f-2fbfc8fd90c0/aa542f2f158cc6c9e63b4287e4618f0a/dotnet-hosting-8.0.5-win.exe'
    Checksum64 = 'cf3d170c977acd119cf3a261e88ac51de86f165fde01d4545951a145fbbecd62d9d6a6e2af3630065d982a14b264e10f5980c2de72ef3c6e49097dd4c18e03d0'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
