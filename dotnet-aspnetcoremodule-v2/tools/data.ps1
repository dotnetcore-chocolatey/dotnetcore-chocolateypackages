@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://download.visualstudio.microsoft.com/download/pr/680964e9-9a8f-48b8-a1d4-c67ee809e5ba/7eec74d77d93ffa51eee2117aea60876/dotnet-hosting-9.0.0-rc.2.24474.3-win.exe'
    Checksum = '270a38e4318a2783f1f3462b727304124bbc801a20ae1e6cef99200d8c5ee5d4991791876455b00df409b52d9f64ba7358e024e6f342cfae463654da9d078d73'
    ChecksumType = 'sha512'
    Url64 = 'https://download.visualstudio.microsoft.com/download/pr/680964e9-9a8f-48b8-a1d4-c67ee809e5ba/7eec74d77d93ffa51eee2117aea60876/dotnet-hosting-9.0.0-rc.2.24474.3-win.exe'
    Checksum64 = '270a38e4318a2783f1f3462b727304124bbc801a20ae1e6cef99200d8c5ee5d4991791876455b00df409b52d9f64ba7358e024e6f342cfae463654da9d078d73'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
