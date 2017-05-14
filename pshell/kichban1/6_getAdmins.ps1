# recive ip from cmd
param([String]$ip)

echo "Get user administrator on computer: $ip"
$userlogon = Read-Host "User logon"
#$userlogon = "Administrator"

$groups = gwmi -Class win32_groupuser -ComputerName $ip -Credential $userlogon
$admins = $groups | ? {$_.GroupComponent -like '*"Administrators"'}

echo "User administrator"
echo "------------------"
foreach($admin in $admins){
    $user = $admin | select PartComponent

    $begin = "$user".IndexOf('Name="')+6
    $end = "$user".IndexOf('"',$begin)
    $user = "$user".Substring($begin, $end - $begin)

    echo $user
}