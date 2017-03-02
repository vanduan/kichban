#!bin/bash
#2. Thiet lap cau hinh IP cho ds may: chuyen tu ip tinh sang dhcp
# (tham khao file /etc/network/interface)
#- Input: file chua ds may: d/cIP/ten may
#- Output: file chua ketqua thuc hien: d/cIP/tenmay:OK/No
[ $# = 1 ] || {
	echo "Usage: $0 <file_input>";
	exit 1;
}

#main
echo "d/cIP/tenmay:OK/No" > "$1.out"
while read pc
do
	echo "\n$pc"
	ping $pc -c3 > /dev/null
	[ $? != 0 ] && {
		echo "$pc: ERROR: Can't connect!"; #display
		echo "$pc: ERROR: Can't connect!" >> "$1.out";
		continue;
	}
	# get iface
	ifaces=`ssh $pc "grep auto /etc/network/interfaces | cut -d' ' -f2"`
	#echo $iface
	# config
	for i in $ifaces
	do
		# iface loopback
		[ "$i" = "lo" ] && { continue; }
		# dhcp??
		echo "$pc: iface $i" #display
		ssh $pc "grep '$i inet dhcp' /etc/network/interfaces" > /dev/null
		[ `ssh $pc echo $?` = 0 ] && {
			echo "$pc: iface $i: OK: dhcp is enable"; #display
			echo "$pc:OK" >> "$1.out"; 
			continue;
		}
		# enable dhcp
		ssh $pc "sudo sed -i 's/$i inet static/$i inet dhcp/' /etc/network/interfaces"
		# success		
		[ `ssh $pc echo $?` = 0 ] && { 
			echo "$pc: iface $i: OK: enable success"; #display
			echo "$pc:OK" >> "$1.out";
			# reload
			ssh $pc sudo service networking reload
			continue; 
			}
		# not success
		echo "$pc: iface $i: No: enable not success"; #display		
		echo "$pc:No"; >> "$1.out"
	done
done < $1
