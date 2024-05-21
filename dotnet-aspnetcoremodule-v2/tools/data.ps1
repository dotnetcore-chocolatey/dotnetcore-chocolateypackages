@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://download.visualstudio.microsoft.com/download/pr/dc7f36ba-c8ca-4dbb-9fc6-ba10ec01c36f/fd73f2c002241fec538305a8cf26c203/dotnet-hosting-9.0.0-preview.4.24267.6-win.exe'
    Checksum = '19885f297d2f01e20b46b69c48b8a1fd02aaaa9bf44ab7ca8b7a8ae961b0147bfdff8b8a63cf2766fb6bbb8ffe3d5dac80b1efe2a12bc4a91cd798abcb09ae4d'
    ChecksumType = 'sha512'
    Url64 = 'https://download.visualstudio.microsoft.com/download/pr/dc7f36ba-c8ca-4dbb-9fc6-ba10ec01c36f/fd73f2c002241fec538305a8cf26c203/dotnet-hosting-9.0.0-preview.4.24267.6-win.exe'
    Checksum64 = '19885f297d2f01e20b46b69c48b8a1fd02aaaa9bf44ab7ca8b7a8ae961b0147bfdff8b8a63cf2766fb6bbb8ffe3d5dac80b1efe2a12bc4a91cd798abcb09ae4d'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
