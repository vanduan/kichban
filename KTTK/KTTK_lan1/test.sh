#!/bin/bash

[ $# -eq 1 ] || {
	echo "Usage: $0 <file_name>";
	exit 1;
}

while read line
do
	# lấy thông tin từ file
	pc=$(echo $line | cut -d'-' -f1)
	login_user=$(echo $line | cut -d'-' -f2)
	new_name=$(echo $line | cut -d'-' -f3)
	service=$(echo $line | cut -d'-' -f4)
	# lấy ip và hostname từ /etc/host
	ip=$(grep $pc /etc/hosts | head -n1 | cut -f1)
	old_name=$(grep $pc /etc/hosts | head -n1 | cut -f2)
	# tạo file KQ.txt
	echo "<tên cũ> - <địa chỉ IP> - <tên mới> - <Yes/No tương ứng với dịch vụ chạy/không>" > KQ.txt;
	# kiểm tra kết nối tới pc
	ping $pc -c 3 > /dev/null
	[ $? = 0 ] || {
		echo "$old_name - $ip - Can't connect - No" >> KQ.txt;
		echo "$old_name - $ip - Can't connect - No";
		continue;
	}
	# đổi tên hostname
	ssh $login_user@$pc hostname "$new_name"
	# không biết làm :))
	service_status="Unknow"
	
	echo "$old_name - $ip - $new_name - $service_status"
	echo "$old_name - $ip - $new_name - $service_status" >> KQ.txt
done < $1
