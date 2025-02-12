@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://download.visualstudio.microsoft.com/download/pr/785df3b0-8483-4eb0-8826-3cfb0d708ba7/28ad125421135a4fad3f03cea41cd673/dotnet-hosting-9.0.2-win.exe'
    Checksum = 'b275c7f67f46d8d65da5fd07dadf52ab544d5f40aad02c12dc24c1460b8a92b6b5ba418101c4a5e29c29e547eb3c1c794e40fb8531a5e4d35233fdc8e12312eb'
    ChecksumType = 'sha512'
    Url64 = 'https://download.visualstudio.microsoft.com/download/pr/785df3b0-8483-4eb0-8826-3cfb0d708ba7/28ad125421135a4fad3f03cea41cd673/dotnet-hosting-9.0.2-win.exe'
    Checksum64 = 'b275c7f67f46d8d65da5fd07dadf52ab544d5f40aad02c12dc24c1460b8a92b6b5ba418101c4a5e29c29e547eb3c1c794e40fb8531a5e4d35233fdc8e12312eb'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
