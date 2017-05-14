$a = New-Object -ComObject Shell.Application
$rb = $a.NameSpace(0x0a)
$rb.Items | select *