@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://download.visualstudio.microsoft.com/download/pr/1eb7f78f-c605-4e38-b5b0-33b58ccb8460/c7421e8b5616b751a9a66c0c5abba81d/dotnet-hosting-9.0.0-preview.5.24306.11-win.exe'
    Checksum = '04a1299e7fbf65ad6587f58013c03cb557e34790193aeb98af95a29e26bf836649730d76060042b0a99566d85b02f4aa69a5558aa777865b087bd59cb6f8d836'
    ChecksumType = 'sha512'
    Url64 = 'https://download.visualstudio.microsoft.com/download/pr/1eb7f78f-c605-4e38-b5b0-33b58ccb8460/c7421e8b5616b751a9a66c0c5abba81d/dotnet-hosting-9.0.0-preview.5.24306.11-win.exe'
    Checksum64 = '04a1299e7fbf65ad6587f58013c03cb557e34790193aeb98af95a29e26bf836649730d76060042b0a99566d85b02f4aa69a5558aa777865b087bd59cb6f8d836'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
