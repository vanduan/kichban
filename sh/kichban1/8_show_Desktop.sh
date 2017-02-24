#!/bin/bash
# Lay noi dung Desktop cua nguoi dung dang logon
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
user=`ssh $1 "who -q | head -n1"`
echo "User loged: $user"
echo "Show Desktop: \n ----------"
ssh $1 ls ~$user/Desktop/
