@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://download.visualstudio.microsoft.com/download/pr/d60623ee-292d-464d-8444-54a06b95900a/07ca68bd595ce56e097efd7b7573dff2/dotnet-hosting-10.0.0-preview.1.25120.3-win.exe'
    Checksum = 'a417fde9b7e1d143408d74b8a92999337221b2042c558e83e0fba34f8706ed024b3208ffd4b4125ea4e1821d8fffc46b47425a016b272e18fe415c724831f525'
    ChecksumType = 'sha512'
    Url64 = 'https://download.visualstudio.microsoft.com/download/pr/d60623ee-292d-464d-8444-54a06b95900a/07ca68bd595ce56e097efd7b7573dff2/dotnet-hosting-10.0.0-preview.1.25120.3-win.exe'
    Checksum64 = 'a417fde9b7e1d143408d74b8a92999337221b2042c558e83e0fba34f8706ed024b3208ffd4b4125ea4e1821d8fffc46b47425a016b272e18fe415c724831f525'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
