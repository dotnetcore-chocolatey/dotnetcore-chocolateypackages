@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://download.visualstudio.microsoft.com/download/pr/6728a941-7b39-44af-b75c-91769681007d/0f062452057e1f17bcf2e1af7e2a5414/dotnet-hosting-9.0.0-preview.1.24081.5-win.exe'
    Checksum = '67a972f36f9e31417e6746b9ea69fc033e945708c2e43be665239ac16f561e92960240f789d942ae886b4d4a38a49e1ed226e5b92f0eeb1e66d178c760cd4960'
    ChecksumType = 'sha512'
    Url64 = 'https://download.visualstudio.microsoft.com/download/pr/6728a941-7b39-44af-b75c-91769681007d/0f062452057e1f17bcf2e1af7e2a5414/dotnet-hosting-9.0.0-preview.1.24081.5-win.exe'
    Checksum64 = '67a972f36f9e31417e6746b9ea69fc033e945708c2e43be665239ac16f561e92960240f789d942ae886b4d4a38a49e1ed226e5b92f0eeb1e66d178c760cd4960'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
