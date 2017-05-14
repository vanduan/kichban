param($ip)

$username = Read-Host "enter username"

$result = Get-WmiObject -Class win32_useraccount -ComputerName $ip | where {$_.name -eq $username} 

#$result

if("$result".Length -gt 0){ echo "===> User is exist"}
else { echo "===> User is not exist"}