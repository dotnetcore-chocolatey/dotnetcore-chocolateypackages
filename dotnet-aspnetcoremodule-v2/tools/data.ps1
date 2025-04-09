@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.4/dotnet-hosting-9.0.4-win.exe'
    Checksum = 'e02d6e48361bc09f84aefef0653bd1eaa1324795d120758115818d77f1ba0bca751dcc7e7c143293c7831fd72ff566d7c2248d1cb795f8d251c04631bc4459ea'
    ChecksumType = 'sha512'
    Url64 = 'https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.4/dotnet-hosting-9.0.4-win.exe'
    Checksum64 = 'e02d6e48361bc09f84aefef0653bd1eaa1324795d120758115818d77f1ba0bca751dcc7e7c143293c7831fd72ff566d7c2248d1cb795f8d251c04631bc4459ea'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
