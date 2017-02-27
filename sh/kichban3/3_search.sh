#!bin/bash
#3. Thiet lap cau hinh search (file /etc/resolv.conf) cho ds may
#- Input: file chua ds may: d/cIP/ten may:search domain
#  vidu: 192.168.1.20:fit.iuh.edu
#- Output: file chua ketqua thuc hien: d/cIP/tenmay:search domain cu: search domain moi

[ $# = 1 ] || {
	echo "Usage: $0 <file_input>";
	exit 1;
}

echo "<<d/cIP/tenmay:ten search cu:ten search moi>>" > "$1.out"

#main
while IFS=: read pc new_s
do
	# check connection
	ping $pc -c3 > /dev/null
	[ $? != 0 ] && {
		echo "$pc:$new_s : ERROR: Can't connect" >> "$1.out";
		continue;
	}
	# get search 
	old_s=`ssh $pc "grep "search" /etc/resolv.conf"`
	# check SSH connection
	[ $? != 0 ] && {
		echo "$pc:$new_s : ERROR: ssh: Connection refused" >> "$1.out";
		continue; 
	}
	# set search
	ssh $pc "sed -i 's/^search.*/search $new_s/' /etc/resolv.conf"
	echo "$pc:$old_s:search $new_s" >> "$1.out"
done < $1
echo "DONE\n"
