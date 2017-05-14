# recive ip from cmd
param($ip)

get-wmiobject -class "win32_networkadapterconfiguration" -computername $ip | Select-Object description, ipaddress, dnsserversearchorder