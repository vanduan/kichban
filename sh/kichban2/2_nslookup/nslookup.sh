#!/bin/bash

# if [ $# -eq 0 ]
if test $# -eq 0
then
	echo "Usage: $0 <file_computer_name>\n"
	exit 1
fi

# check file
[ -f $1 ] || { echo "File not found!\n"; exit 1; }
[ -s $1 ] || { echo "File is empty!\n"; exit 1; }

echo "" > "$1.out"
# main
while read pcname
do
	nslookup $pcname > /dev/null
	[ $? = 0 ] || { echo "Can't find computer $pcname"; echo "Can't find computer $pcname" >> "$1.out"; }
done < $1
