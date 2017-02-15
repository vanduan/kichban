#!/bin/bash
# script to list file, subdir & symbol link in directory

if [ $# -eq 0 ]
then
	echo "\nUsage: $0 <a_directory>\n"
	exit 1
fi
 
DIR=$1

[ -d $DIR ] || { echo "\nNo such directory.\n"; exit 1; }

list=$(ls $DIR)

# list subdir
echo "Subdir:" > subdir
for i in $list
do
	path="$DIR/$i"
	[ -d $path ] && echo "   |-- $path" >> subdir; 
done

# list file execute
echo "File execute:" > file_exec
for i in $list
do
	path="$DIR/$i"
        [ -f $path ] && [ -x $path ] && echo "   |-- $path" >> file_exec
done

# list symbolic link
echo "Symbolic link:" > link_symbol
for i in $list
do
	path="$DIR/$i"
        [ -h $path ] && echo "   |-- $path" >> link_symbol
done
