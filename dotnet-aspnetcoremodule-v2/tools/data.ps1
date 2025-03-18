@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://download.visualstudio.microsoft.com/download/pr/f20a7d7d-b236-4210-9aec-1dc05054d6fe/0fb9a0f364be9b109f8edad079336926/dotnet-hosting-10.0.0-preview.2.25164.1-win.exe'
    Checksum = '32c3ff68d5fd6e6f850ffe846edb16d94f15ecbe015ddcc76175b4907eef4982fc613744dda63e1365e93352fedc57372297228caa829cb75e5de7d5c6c368bf'
    ChecksumType = 'sha512'
    Url64 = 'https://download.visualstudio.microsoft.com/download/pr/f20a7d7d-b236-4210-9aec-1dc05054d6fe/0fb9a0f364be9b109f8edad079336926/dotnet-hosting-10.0.0-preview.2.25164.1-win.exe'
    Checksum64 = '32c3ff68d5fd6e6f850ffe846edb16d94f15ecbe015ddcc76175b4907eef4982fc613744dda63e1365e93352fedc57372297228caa829cb75e5de7d5c6c368bf'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
