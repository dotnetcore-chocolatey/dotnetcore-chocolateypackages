# based on Get-RemoteChecksum from AU, with different progress indication
# (progress shown by Invoke-WebRequest slows it down tremendously)
function Get-RemoteChecksumFast( [string] $Url, $Algorithm='sha256' ) {
    $pp = $ProgressPreference
    $act = "Obtaining checksum of $Url"
    Write-Progress -Activity $act -CurrentOperation 'Creating temporary file'
    $fn = [System.IO.Path]::GetTempFileName()
    Write-Progress -Activity $act -CurrentOperation 'Downloading remote file'
    $ProgressPreference = 'SilentlyContinue'
    try
    {
        Invoke-WebRequest $Url -OutFile $fn -UseBasicParsing
    }
    finally
    {
        $ProgressPreference = $pp
    }
    Write-Progress -Activity $act -CurrentOperation 'Computing the checksum of downloaded file'
    $res = Get-FileHash $fn -Algorithm $Algorithm | % Hash
    Write-Progress -Activity $act -CurrentOperation 'Removing temporary file'
    rm $fn -ea ignore
    Write-Progress -Activity $act -Completed
    return $res.ToLower()
}
