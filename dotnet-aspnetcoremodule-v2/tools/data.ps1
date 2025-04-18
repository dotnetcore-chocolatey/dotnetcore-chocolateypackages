@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.3.25172.1/dotnet-hosting-10.0.0-preview.3.25172.1-win.exe'
    Checksum = '08aa4c6bf1e014a6d6140b1e51c2ef3a444a87f0bb669d10f3438604b9d7a7d7fb56db5befc8c4a29edf90e1cbeb39e62fe272d99316350ca49cea4f1fcd8796'
    ChecksumType = 'sha512'
    Url64 = 'https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.3.25172.1/dotnet-hosting-10.0.0-preview.3.25172.1-win.exe'
    Checksum64 = '08aa4c6bf1e014a6d6140b1e51c2ef3a444a87f0bb669d10f3438604b9d7a7d7fb56db5befc8c4a29edf90e1cbeb39e62fe272d99316350ca49cea4f1fcd8796'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
