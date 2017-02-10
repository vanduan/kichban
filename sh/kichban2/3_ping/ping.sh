#!/bin/bash

if [ $# = 0 ]
then
        echo "Usage: $0 <file_name_IP>\n"
        exit 1
fi

# check file
[ -f $1 ] || { echo "File not found!\n"; exit 1; }
[ -s $1 ] || { echo "File is empty!\n"; exit 1; }

echo "" > "$1.out"
# main
while read ip
do
	ping $ip -c 3 > /dev/null
	[ $? = 0 ] || { echo "Can't connect to $ip"; echo "Can't connect to $ip" >> "$1.out"; }
done < $1
