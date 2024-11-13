@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://download.visualstudio.microsoft.com/download/pr/e1ae9d41-3faf-4755-ac27-b24e84eef3d1/5e3a24eb8c1a12272ea1fe126d17dfca/dotnet-hosting-9.0.0-win.exe'
    Checksum = '07857f982392d18b0aae269fb455573a3a02dce7bd6cd9fc476b514b1792430dfb793799606a7cd7afcd80813ca269abfa5427520e9b4ac589288d6de8eb1a4f'
    ChecksumType = 'sha512'
    Url64 = 'https://download.visualstudio.microsoft.com/download/pr/e1ae9d41-3faf-4755-ac27-b24e84eef3d1/5e3a24eb8c1a12272ea1fe126d17dfca/dotnet-hosting-9.0.0-win.exe'
    Checksum64 = '07857f982392d18b0aae269fb455573a3a02dce7bd6cd9fc476b514b1792430dfb793799606a7cd7afcd80813ca269abfa5427520e9b4ac589288d6de8eb1a4f'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
