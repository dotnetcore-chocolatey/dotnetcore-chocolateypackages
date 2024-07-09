@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://download.visualstudio.microsoft.com/download/pr/4d1bd32e-b91d-47dd-adde-e9871ff54127/b47f402aca31e6c2093f3f55c069f84f/dotnet-hosting-9.0.0-preview.6.24328.4-win.exe'
    Checksum = '5820ce5df0099855ce078b8f7c2039f6680afa9f3a7374d20d33624a0774026533b98cfa48b9d846257a8c1b17fb5e843476d23c6b49687b412270a4b670ca04'
    ChecksumType = 'sha512'
    Url64 = 'https://download.visualstudio.microsoft.com/download/pr/4d1bd32e-b91d-47dd-adde-e9871ff54127/b47f402aca31e6c2093f3f55c069f84f/dotnet-hosting-9.0.0-preview.6.24328.4-win.exe'
    Checksum64 = '5820ce5df0099855ce078b8f7c2039f6680afa9f3a7374d20d33624a0774026533b98cfa48b9d846257a8c1b17fb5e843476d23c6b49687b412270a4b670ca04'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
