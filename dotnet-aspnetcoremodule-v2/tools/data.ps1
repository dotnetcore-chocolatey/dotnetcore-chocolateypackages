@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://download.visualstudio.microsoft.com/download/pr/450a6e4e-e4e3-4ed6-86a2-6a6f840e5a51/3629f0822ccc2ce265cf5e88b5b567cb/dotnet-hosting-9.0.1-win.exe'
    Checksum = 'aa468f04071201827889d97bdf4c899bde5dd5ef9590b368761a40d5bf1db75ed7e647cc8580bd0f5676035e35d52c2e9b687f2dffc2995a372326f786145d6a'
    ChecksumType = 'sha512'
    Url64 = 'https://download.visualstudio.microsoft.com/download/pr/450a6e4e-e4e3-4ed6-86a2-6a6f840e5a51/3629f0822ccc2ce265cf5e88b5b567cb/dotnet-hosting-9.0.1-win.exe'
    Checksum64 = 'aa468f04071201827889d97bdf4c899bde5dd5ef9590b368761a40d5bf1db75ed7e647cc8580bd0f5676035e35d52c2e9b687f2dffc2995a372326f786145d6a'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
