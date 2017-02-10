#!/bin/bash

if [ $# = 0 ]
then
        echo "Usage: $0 <file_name_user>\n"
        exit 1
fi

# check file
[ -f $1 ] || { echo "File not found!\n"; exit 1; }
[ -s $1 ] || { echo "File is empty!\n"; exit 1; }

printf "%10s     %-30s\n -------------------------\n" "User" "Groups" > "$1.out"
# main
while read user
do
        data=$(groups $user) # get group data
        [ $? = 0 ] && {
		groups=$(echo $data | cut -d':' -f2);
		printf "%10s  -  %-30s\n" "$user" "$groups" >> "$1.out";
		continue;
	}
done < $1
echo "\n ==> Done <== \n"
