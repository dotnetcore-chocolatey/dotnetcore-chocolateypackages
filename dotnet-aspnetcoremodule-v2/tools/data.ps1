@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://download.visualstudio.microsoft.com/download/pr/bab2ec4f-c930-44be-9b7d-38b9f837b3af/5ad4812b54c7588622b9eb10fd0de616/dotnet-hosting-9.0.0-preview.2.24128.4-win.exe'
    Checksum = 'a959ade3fa01e191bf8b03adc89247a1a45374d354e3c27db06927e8e692d8368974e918ecf27a1a0bcd2020f2f11212d878d64a389f907345d053aa79b65449'
    ChecksumType = 'sha512'
    Url64 = 'https://download.visualstudio.microsoft.com/download/pr/bab2ec4f-c930-44be-9b7d-38b9f837b3af/5ad4812b54c7588622b9eb10fd0de616/dotnet-hosting-9.0.0-preview.2.24128.4-win.exe'
    Checksum64 = 'a959ade3fa01e191bf8b03adc89247a1a45374d354e3c27db06927e8e692d8368974e918ecf27a1a0bcd2020f2f11212d878d64a389f907345d053aa79b65449'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
