@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://download.visualstudio.microsoft.com/download/pr/f28df469-8a85-4d55-9c4c-957b8c79a7d0/902f993af8ee3aaaf646bc55c4cf668f/dotnet-hosting-9.0.0-preview.3.24172.13-win.exe'
    Checksum = 'bf6f9cbe3dea1e45f7fe831d9a8ccbb46f744c479f22449908e328a388d8517f5f38caac5cd8345166279b79f653a040399a85f18f75da63d983199ddd1ca340'
    ChecksumType = 'sha512'
    Url64 = 'https://download.visualstudio.microsoft.com/download/pr/f28df469-8a85-4d55-9c4c-957b8c79a7d0/902f993af8ee3aaaf646bc55c4cf668f/dotnet-hosting-9.0.0-preview.3.24172.13-win.exe'
    Checksum64 = 'bf6f9cbe3dea1e45f7fe831d9a8ccbb46f744c479f22449908e328a388d8517f5f38caac5cd8345166279b79f653a040399a85f18f75da63d983199ddd1ca340'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
