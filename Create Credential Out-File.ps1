## Create Credential Out-Files
Function Set-CredentialFile {
    Param (
        [parameter(Position=0, ParameterSetName="PrivilegedAccount")]
        [switch]$PrivilegedAccount,
        [parameter(Position=0, ParameterSetName="CloudAccount")]
        [switch]$CloudAccount
    )

    If ($PrivilegedAccount) {Read-Host -Prompt "Enter your privileged account password" -AsSecureString | ConvertFrom-SecureString | Out-File "$($env:userprofile)\filename_priv.txt"}
    ElseIf ($CloudAccount) {Read-Host -Prompt "Enter your cloud admin account password" -AsSecureString | ConvertFrom-SecureString | Out-File "$($env:userprofile)\filename.txt"}
    If (!$PrivilegedAccount -and !$CloudAccount) {
        Write-Warning "You must use '-PrivilegedAccount' or '-CloudAccount' to update a credential file(s)."
    }
}