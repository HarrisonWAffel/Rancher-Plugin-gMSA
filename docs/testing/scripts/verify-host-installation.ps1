<#
.SYNOPSIS
    When run on a node which has installed the Rancher gMSA CCG plugin and account provider,
    this script checks various files and directories to ensure that the installation and registration
    completed successfully.

.PARAMETER AccountProviderNamespace
    The kubernetes namespace the account provider was deployed in. This namespace is used to write
    directories on the host.

.PARAMETER Uninstall
    Indicates that the script should ensure that files do not exist after an uninstallation of the solution.
#>

param (
    [String]
    $AccountProviderNamespace,

    [Switch]
    $Uninstall
)

function Write-Status {
    $now = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    Write-Host -NoNewline "$now INFO: "
    Write-Host -ForegroundColor Gray ("=== {0} ===" -f ($args -join " "))
}

$success = $true

$CCGPaths = @(
    "C:\Program Files\RanchergMSACredentialProvider\RanchergMSACredentialProvider.dll",
    "C:\Program Files\RanchergMSACredentialProvider\RanchergMSACredentialProvider.tlb",
    "C:\Program Files\RanchergMSACredentialProvider\install-plugin.ps1"
)

$accountProviderPaths = @(
    "/var/lib/rancher/gmsa/$AccountProviderNamespace/port.txt",
    "/var/lib/rancher/gmsa/$AccountProviderNamespace/ssl/client/tls.pfx",
    "/var/lib/rancher/gmsa/$AccountProviderNamespace/ssl/client/tls.crt",
    "/var/lib/rancher/gmsa/$AccountProviderNamespace/ssl/server/tls.crt",
    "/var/lib/rancher/gmsa/$AccountProviderNamespace/ssl/server/ca.crt",
    "/var/lib/rancher/gmsa/$AccountProviderNamespace/ssl/ca/tls.crt",
    "/var/lib/rancher/gmsa/$AccountProviderNamespace/ssl/ca/ca.crt"
)

$missingPaths = @()

Write-Status "Checking CCG Plugin Paths"
foreach ($path in $CCGPaths) {
    if ((Test-Path -Path $path) -and (-Not $Uninstall)) {
        Write-Host "$path PASS"
    } else {
        Write-Host "$path FAIL"
        $success = $false
        $missingPaths += "CCG Plugin: $path"
    }
}

Write-Status "Checking Account Provider Paths"
foreach ($path in $accountProviderPaths) {
    if ((Test-Path -Path $path) -and (-Not $Uninstall)) {
        Write-Host "$path PASS"
    } else {
        Write-Host "$path FAIL"
        $success = $false
        $missingPaths += "Account Provider: $path"
    }
}

if ($success) {
    Write-Status "SUCC: All expected paths succeeded"
} else {
    Write-Status "FAIL: Some paths did not pass expected checks"
    Write-Host "The following paths were not correct"
    foreach ($path in $missingPaths) {
        Write-host $path
    }
}