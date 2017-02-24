#!/bin/bash
#Hien thi danh sach nguoi dung cua nhom Admin.
[ $# = 1 ] || {
	echo "Usage: $0 <ip address>";
	exit 1;
}

# check ip
isvalidip(){
	case $1 in "" | *[!0-9.]* | *[!0-9]) return 1;;
	esac
	local IFS=.
	set -- $1
	
	[ $# -eq 4 ] && [ ${1:-666} -le 255 ] && [ ${2:-666} -le 255 ] && [ ${3:-666} -le 255 ] && [ ${4:-666} -le 255 ]
}

if ! isvalidip "$1"
then
	echo "Invalid IP address"
	exit 1
fi

# check connection
ping $1 -c3 > /dev/null
[ $? = 0 ] || {
	echo "Can't connect to $1";
	exit 1;
}

# main
users=`ssh $1 grep sudo /etc/group | cut -d':' -f4`
echo "Users of Admin group: $users"
