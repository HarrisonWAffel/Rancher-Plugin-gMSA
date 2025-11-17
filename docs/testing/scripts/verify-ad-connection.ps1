<#
.SYNOPSIS
    When run inside of a gMSA enabled container, this script checks that the AD connection is correct and that the gMSA has been correctly assumed.

.PARAMETER ComputerName
    [Specifies the target computer(s) for the script to run against. The default is the local computer.]

.PARAMETER Credential
    [Specifies a user account that has permission to perform this action. The default is the current user.]
#>
param (
    [String]
    $ADParent
)

$parentOut = $(nltest /parentdomain)
Write-Host $parentOut

if (-Not ($parentOut -like $ADParent)) {
    Write-Host "ERR: Expected parent domain was not found in '/parentdomain' output. Output:"
} else {
    Write-Host "/parentdomain returned expected value"
}

$queryOut = $(nltest /query)
Write-Host $queryOut
if (-Not ($queryOut -like "NERR_Success")) {
    Write-Host "ERR: /query did not return successfully. Output:"
} else {
    Write-Host "/query returned expected value"
}

$sc_queryOut = $(nltest /sc_query:$ADParent)
Write-Host $sc_queryOut
if (-Not ($sc_queryOut -like "NERR_Success")) {
    Write-Host "ERR: /sc_query did not return successfully. Output:"
} else {
    Write-Host "/sc_query returned expected value"
}