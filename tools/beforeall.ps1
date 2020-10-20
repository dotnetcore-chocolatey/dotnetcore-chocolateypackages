Import-Module -Name $PSScriptRoot\PSModules\DotNetPackageTools\DotNetPackageTools.psm1
Get-DotNetUpdateInfo -IgnoreCache -AllChannels | Out-Null
