@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://download.visualstudio.microsoft.com/download/pr/712e0fb1-575c-44f8-9253-3b32ef25e122/763e1cbd0aac7cefe69d2b720316770c/dotnet-hosting-9.0.3-win.exe'
    Checksum = '47ac3ebd0b58125d022215516b471e425af17a5cf65d63ae5b38b2ec55bf89c981bb56acbb6977dcab4f77278f12b5fdf9034ec20246e12343a65f76eeb0b798'
    ChecksumType = 'sha512'
    Url64 = 'https://download.visualstudio.microsoft.com/download/pr/712e0fb1-575c-44f8-9253-3b32ef25e122/763e1cbd0aac7cefe69d2b720316770c/dotnet-hosting-9.0.3-win.exe'
    Checksum64 = '47ac3ebd0b58125d022215516b471e425af17a5cf65d63ae5b38b2ec55bf89c981bb56acbb6977dcab4f77278f12b5fdf9034ec20246e12343a65f76eeb0b798'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
