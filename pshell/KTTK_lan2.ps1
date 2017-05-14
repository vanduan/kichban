# Date : 14/04/2017
# name : Pham Van Duan
# email: vanduan95.dvp@gmail.com
# OS   : Windows 10 (ver 1703) 

# $PSVersiontable
# Name                           Value                                                                                                                                                 
# ----                           -----                                                                                                                                                 
# PSVersion                      5.1.15063.138                                                                                                                                         
# PSEdition                      Desktop                                                                                                                                               
# PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}                                                                                                                               
# BuildVersion                   10.0.15063.138                                                                                                                                        
# CLRVersion                     4.0.30319.42000                                                                                                                                       
# WSManStackVersion              3.0                                                                                                                                                   
# PSRemotingProtocolVersion      2.3                                                                                                                                                   
# SerializationVersion           1.1.0.1  

#trap {"Error!!!"; continue;}


function menu(){
    Write-Host ""
    Write-Host "              KIEM TRA THUONG KI (LAN 2)"
    Write-Host " ========================================================="
    Write-Host " 1. Liet ke ten, ID cua cac process duoc chay tu nguoi dung network service"
    Write-Host " 2. Lay thong tin ve WorkingSet cua cac qua trinh dang chay voi nguoi dung login"
    Write-Host " 3. Liet ke ten, trang thai (enable/ disable) cua cac user tuong tac"
    Write-Host " 4. Enable user Guest neu chua duoc enable"
    Write-Host " 5. Liet ke danh sach dia chi IP cua tat ca cac NIC co ho tro TCP/IP"
    Write-Host " 6. Liet ke bang duong di cua cac NIC dang enable"
    Write-Host " 7. Liet ke sanh sach cac port lon hon 1024 dang mo (co kem ten dich vu hay program su dung port)"
    Write-Host " 8. Liet ke danh muc cac cookies"
    Write-Host " 9. Liet ke history cua IE"
    Write-Host " 10. Xoa noi dung trong thung rac"
    Write-Host " 0. Ket thuc" -BackgroundColor Cyan
    Write-Host " ============================"
    $choise = Read-Host " Chon di"
    return $choise
}

function continu(){
    Write-Host ""
    Write-Host " (Thu lai nhieu lan neu chua duoc)" -ForegroundColor Yellow
    $temp = Read-Host " =====>>> Nhan Enter de tiep tuc"
}

while($true){
    switch(menu){
        0 {
            exit(0)
        }
        1 {
            cls
            Write-Host "  Mot so may khong the thuc hien chuc nang nay" -BackgroundColor DarkMagenta

            $pcs = gwmi -Class win32_process
            foreach($pc in $pcs){
                $user = $pc.GetOwner() | select User
                # một số may (Windows 10) thuộc tính user = ""
                # Windows 7 chay tốt :))
                if ($user -like "*network service*"){
                    $pc | select Name, ProcessID
                }
            }
            
            continu
        } 
        2 {
            cls
            
            $pcs = gwmi -Class win32_process
            foreach($pc in $pcs){
                $user = $pc.GetOwner() | select User
                if ($user -like "*$env:UserName*"){
                    $pc | select Name, WorkingSetSize
                }
            }
            
            continu
        } 
        3 {
            cls

            gwmi -Class win32_UserAccount | ? {$_.AccountType -eq "512"} | select Name, Disabled
            
            continu
        } 
        4 {
            cls

            echo "Chua biet lam sao :("
            
            continu
        } 
        5 {
            cls

            foreach ($nic1 in $(Get-NetAdapter)){
                foreach ($nic2 in $(gwmi -Class win32_NetworkAdapterConfiguration)){
                    if($nic1.InterfaceDescription -eq $nic2.Description){
                        $nic2 | select Index, Description, IPAddress
                    }
                }
            }

            continu
        } 
        6 {
            cls

            foreach ($nic in $(Get-NetAdapter)){
                Write-Host " "
                Write-Host " =====>>>> " $nic.InterfaceDescription -BackgroundColor DarkGreen
                Get-NetRoute | ? {$_.ifIndex -eq $nic.ifIndex} | select ifIndex, DestinationPrefix,  NextHop, RouteMetric, ifMetric
            }

            continu
        } 
        7 {
            cls

            $cons = Get-NetTCPConnection | ? {$_.LocalPort -gt 1024}
            $pcs = Get-Process
            Write-Host "LocalPort`tProcessName"
            Write-Host "=========`t==========="
            foreach($con in $cons){
                Write-Host -NoNewline $con.LocalPort `t`t
                foreach($pc in $pcs){
                    if($pc.Id -eq $con.OwningProcess){
                        Write-Host $pc.ProcessName
                    }
                }
            }

            continu
        }
        8 {
            cls

            $shell = New-Object -ComObject Shell.Application
            $cookies = $shell.NameSpace(0x21)
            ls $cookies.Self.Path

            continu
        } 
        9 {
            cls

            $shell = New-Object -com Shell.Application
            $his = $shell.NameSpace(0x22)
            
            # timeFolder là tập hợp các foder (Today, Friday, Thursday, ...)
            $timeFolder = $his.Items()
            foreach($tf in $timeFolder){
                $siteFolder = $tf.GetFolder().Items()
                #$siteFolder = $siteFolder.Items()
                foreach($sitef in $siteFolder){
                    if($sitef.Name -ne "This PC"){
                        $pageFolder = $sitef.GetFolder().Items()
                        foreach($page in $pageFolder){
                           $visit = New-Object -TypeName PSObject -Property @{            
                               Site = $($page.Name)            
                               URL = $($sitef.GetFolder().GetDetailsOf($page,0))            
                               Date = $($sitef.GetFolder().GetDetailsOf($page,2))            
                           }            
                           $visit | select Site ,Date, URL
                        }
                    }
                }
            }

            continu
        } 
        10 {
            cls

            $shell = New-Object -com Shell.Application
            $rec = $shell.NameSpace(0x0a)
            
            $rec.Items() | foreach {
                $_ | select Name
            }

            $rec.Self.InvokeVerb("Empty")

            continu
        } 
        default {
        
            Write-Host " Nope!!!" -ForegroundColor "Red" 
        
        }
    }
}
