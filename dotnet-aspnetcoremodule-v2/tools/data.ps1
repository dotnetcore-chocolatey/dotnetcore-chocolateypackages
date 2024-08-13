@{
    PackageName = 'dotnet-aspnetcoremodule-v2'
    Url = 'https://download.visualstudio.microsoft.com/download/pr/fdd84cd2-f012-47c1-bf90-df245aef7fdc/04161e728311f32a1ec0f9f973a9d606/dotnet-hosting-9.0.0-preview.7.24406.2-win.exe'
    Checksum = '84426e1c134c0bf6227ed9610a252c562470b65c76a10153e5123b2939f3daaa2e7e067f65de9629ed8542b480ba8549dd0301b58ad94380b8b35cf096882b56'
    ChecksumType = 'sha512'
    Url64 = 'https://download.visualstudio.microsoft.com/download/pr/fdd84cd2-f012-47c1-bf90-df245aef7fdc/04161e728311f32a1ec0f9f973a9d606/dotnet-hosting-9.0.0-preview.7.24406.2-win.exe'
    Checksum64 = '84426e1c134c0bf6227ed9610a252c562470b65c76a10153e5123b2939f3daaa2e7e067f65de9629ed8542b480ba8549dd0301b58ad94380b8b35cf096882b56'
    ChecksumType64 = 'sha512'
    AdditionalArgumentsToInstaller = 'OPT_NO_RUNTIME=1' # OPT_NO_SHAREDFX=1 removed as a workaround for https://github.com/dotnet/aspnetcore/issues/45395
}
