@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://download.visualstudio.microsoft.com/download/pr/70dcf334-d01f-4025-9648-da1ad1679040/b742a72f09f6b001dbbb1ac530b274f1/dotnet-hosting-9.0.0-rc.1.24452.1-win.exe'
    Checksum = '221f75ee6e5a8fc27ccb24ab8b0fe0da70835f215355700b8ae9d9e278e939f16055793d2726732ba68d1607b778c55694654f7811cd7dc7b3f752606aed0503'
    ChecksumType = 'sha512'
    Url64 = 'https://download.visualstudio.microsoft.com/download/pr/70dcf334-d01f-4025-9648-da1ad1679040/b742a72f09f6b001dbbb1ac530b274f1/dotnet-hosting-9.0.0-rc.1.24452.1-win.exe'
    Checksum64 = '221f75ee6e5a8fc27ccb24ab8b0fe0da70835f215355700b8ae9d9e278e939f16055793d2726732ba68d1607b778c55694654f7811cd7dc7b3f752606aed0503'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
