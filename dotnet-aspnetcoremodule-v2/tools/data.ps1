@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://download.visualstudio.microsoft.com/download/pr/00397fee-1bd9-44ef-899b-4504b26e6e96/ab9c73409659f3238d33faee304a8b7c/dotnet-hosting-8.0.4-win.exe'
    Checksum = '2ae357f0d8e43c316874455ca56adee4d88081bf828721038527760d860beb3b510eca748aa18ebfc9509cd289b51e84156da388853d644cff308b539b04355c'
    ChecksumType = 'sha512'
    Url64 = 'https://download.visualstudio.microsoft.com/download/pr/00397fee-1bd9-44ef-899b-4504b26e6e96/ab9c73409659f3238d33faee304a8b7c/dotnet-hosting-8.0.4-win.exe'
    Checksum64 = '2ae357f0d8e43c316874455ca56adee4d88081bf828721038527760d860beb3b510eca748aa18ebfc9509cd289b51e84156da388853d644cff308b539b04355c'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
