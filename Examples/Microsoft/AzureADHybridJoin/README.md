# Azure AD Hybrid Join connectivity tests

## Usage

1. Import this file: `Import-Module .\AzureADHybridJoinConnectivity.psm1`
1. Run one of the following:
    * `$connectivity = Get-AzureADHybridJoinConnectivity`
    * `$connectivity = Get-AzureADHybridJoinConnectivity -Verbose`
    * `$connectivity = Get-AzureADHybridJoinConnectivity -PerformBlueCoatLookup`
    * `$connectivity = Get-AzureADHybridJoinConnectivity -Verbose -PerformBlueCoatLookup`
1. Filter results: `$connectivity | Format-List -Property Blocked,TestUrl,UnblockUrl,DnsAliases,IpAddresses,Description,Resolved,ActualStatusCode,ExpectedStatusCode,UnexpectedStatus`
1. Save results to a file: `Save-HttpConnectivity -Objects $connectivity -FileName ('AzureADHybridJoinConnectivity_{0:yyyyMMdd_HHmmss}' -f (Get-Date))`

## Tested URLs

| Test URL | URL to Unblock | Description |
| -- | -- | -- |
| <https://enterpriseregistration.windows.net> | <https://enterpriseregistration.windows.net> | |
| <https://login.microsoftonline.com> | <https://login.microsoftonline.com> | |
| | | |
| <https://device.login.microsoftonline.com> | <https://device.login.microsoftonline.com> | |
| <https://autologon.microsoftazuread-sso.com> | <https://autologon.microsoftazuread-sso.com> | |


## References

* [Configure hybrid Azure Active Directory joined devices manually](https://docs.microsoft.com/en-us/azure/active-directory/devices/hybrid-azuread-join-manual-steps)

