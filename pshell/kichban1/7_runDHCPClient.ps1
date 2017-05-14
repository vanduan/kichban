# recive ip from cmd
param([String]$ip)

echo "Get user administrator on computer: $ip"
#$userlogon = Read-Host "User logon"

$userlogon = "Administrator" #default

# get card
$nets = gwmi -Class win32_networkadapterconfiguration -ComputerName $ip -credential $userlogon -Filter "DHCPEnabled = 'False'"

$nets | select description, servicename, dnsdomain, DHCPEnabled

foreach($net in $nets){
    $net.EnableDHCP()
    $net.SetDNSServerSearchOrder()
}