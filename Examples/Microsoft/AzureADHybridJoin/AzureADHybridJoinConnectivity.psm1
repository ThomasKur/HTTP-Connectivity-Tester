Set-StrictMode -Version 4

Import-Module -Name HttpConnectivityTester -Force

# 1. import this file
# Import-Module .\AzureADHybridJoinConnectivity.psm1

# 2. run one of the following:
# $connectivity = Get-AzureADHybridJoinConnectivity
# $connectivity = Get-AzureADHybridJoinConnectivity -Verbose
# $connectivity = Get-AzureADHybridJoinConnectivity -PerformBlueCoatLookup
# $connectivity = Get-AzureADHybridJoinConnectivity -Verbose -PerformBlueCoatLookup

# 3. filter results:
# $connectivity | Format-List -Property Blocked,TestUrl,UnblockUrl,DnsAliases,IpAddresses,Description,Resolved,ActualStatusCode,ExpectedStatusCode,UnexpectedStatus

# 4. save results to a file:
# Save-HttpConnectivity -Objects $connectivity -FileName ('AzureADHybridJoinConnectivity_{0:yyyyMMdd_HHmmss}' -f (Get-Date))

Function Get-AzureADHybridJoinConnectivity() {
    <#
    .SYNOPSIS
    Gets connectivity information for AzureAD Hybrid Join.

    .DESCRIPTION
    Gets connectivity information for AzureAD Hybrid Join.

    .PARAMETER PerformBlueCoatLookup
    Use Symantec BlueCoat SiteReview to lookup what SiteReview category the URL is in.

    .EXAMPLE
    Get-WindowsUpdateConnectivity

    .EXAMPLE
    Get-WindowsUpdateConnectivity -Verbose

    .EXAMPLE
    Get-WindowsUpdateConnectivity -PerformBlueCoatLookup

    .EXAMPLE
    Get-WindowsUpdateConnectivity -Verbose -PerformBlueCoatLookup
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.List[pscustomobject]])]
    Param(
        [Parameter(Mandatory=$false, HelpMessage='Whether to perform a BlueCoat Site Review lookup on the URL. Warning: The BlueCoat Site Review REST API is rate limited.')]
        [switch]$PerformBluecoatLookup
    )

    $isVerbose = $VerbosePreference -eq 'Continue'

    $data = New-Object System.Collections.Generic.List[System.Collections.Hashtable]

    # https://docs.microsoft.com/en-us/azure/active-directory/devices/hybrid-azuread-join-manual-steps

    $data.Add(@{ TestUrl = 'https://enterpriseregistration.windows.net'; ExpectedStatusCode = 404; PerformBluecoatLookup=$PerformBluecoatLookup; Verbose=$isVerbose }) 
    $data.Add(@{ TestUrl = 'https://login.microsoftonline.com';  IgnoreCertificateValidationErrors=$false; PerformBluecoatLookup=$PerformBluecoatLookup; Verbose=$isVerbose })
    $data.Add(@{ TestUrl = 'https://device.login.microsoftonline.com'; IgnoreCertificateValidationErrors=$true; PerformBluecoatLookup=$PerformBluecoatLookup; Verbose=$isVerbose }) 
    $data.Add(@{ TestUrl = 'https://autologon.microsoftazuread-sso.com'; ExpectedStatusCode = 404;  Description = 'URL required for Seamless SSO'; IgnoreCertificateValidationErrors=$true; PerformBluecoatLookup=$PerformBluecoatLookup; Verbose=$isVerbose })
    
    $results = New-Object System.Collections.Generic.List[pscustomobject]

    $data | ForEach-Object {
        $connectivity = Get-HttpConnectivity @_
        $results.Add($connectivity)
    }

    return $results
}
