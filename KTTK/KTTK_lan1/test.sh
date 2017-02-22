#!/bin/bash

[ $# -eq 1 ] || {
	echo "Usage: $0 <file_name>";
	exit 1;
}

while IFS=- read pc
login_user new_name service
do
	# lấy ip và hostname từ /etc/host
	ip=$(grep $pc /etc/hosts | head -n1 | cut -f1)
	# tạo file KQ.txt
	echo "<tên cũ> - <địa chỉ IP> - <tên mới> - <Yes/No tương ứng với dịch vụ chạy/không>" > KQ.txt;
	# kiểm tra kết nối tới pc
	ping $pc -c 3 > /dev/null
	[ $? = 0 ] || {
		echo "$old_name - $ip - Can't connect - No" >> KQ.txt;
		echo "$old_name - $ip - Can't connect - No";
		continue;
	}
	# lấy tên hostname cũ
	old_name=$(ssh $login_user@pc hostname)
	# đổi tên hostname
	ssh $login_user@$pc hostname "$new_name"
	# trạng thái service
	result=$(ssh $login_user@$pc service $service status | grep "running" )
	if $result ! = ""
	then
		service_status="Yes"
	else
		service_status="No"
	fi
	echo "$old_name - $ip - $new_name - $service_status"
	echo "$old_name - $ip - $new_name - $service_status" >> KQ.txt
done < $1
