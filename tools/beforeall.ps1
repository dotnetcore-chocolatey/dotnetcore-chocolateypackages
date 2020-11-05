Import-Module -Name $PSScriptRoot\PSModules\DotNetPackageTools\DotNetPackageTools.psm1

# update release information
Get-DotNetUpdateInfo -IgnoreCache -AllChannels | Out-Null

# generate SDK packages from template
Add-DotNetSdkPackagesFromTemplate
