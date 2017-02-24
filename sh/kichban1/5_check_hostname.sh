#!/bin/bash
# Hien thi ten may (neu may da duoc dat ten)- nguoc lai: dat ten cho may

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

#main
hname=`ssh $1 hostname`
[ "$hname" = "" ] && {
	echo -n "hostname is empty, enter new hostname: ";
	read nname;
	while [ "$nname" = "" ]
	do
		echo -n "enter hostname: "
		read nname
	done
	ssh $1 sudo hostname nname;
	[ `ssh $1 echo $?` = 0 ] || {
		echo "Can't change hostname";
		exit 1;
	}
	echo "hostname was changed to $nname";
	exit 1;
}
echo "hostname: $hname"
