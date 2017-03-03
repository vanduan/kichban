#!bin/bash
# 1. Dat ten va luu tru ten cho 1 ds may:
#  - Input: file chua ds may gom 2 cot: d/cIP/ten may:ten moi
#  - Output: file chua ketqua: d/cIP/tenmay:ten cu:tenmoi

[ $# = 1 ] || {
	echo "Usage: $0 <file_input>";
	exit 1;
}

result="$1.out"
echo "<<d/cIP/tenmay:ten cu:tenmoi>>" > "$result"

#main
for line in `cat $1`
do
	
	# split pc, name
	IFS=:
	set -- $line
	pc=$1
	new_name=$2
	# check connection
	ping $pc -c3 > /dev/null
	[ $? != 0 ] && {
		echo "$pc:$new_name : ERROR: Can't connect" >> "$result";
		continue;
	}
	# get hostname
	old_name=`ssh $pc hostname`
	# check SSH connection
	[ $? != 0 ] && { echo "$pc:$new_name : ERROR: ssh: Connection refused" >> "$result"; continue; }
	# set hostname
	ssh $pc sudo hostname $new_name
	echo "$pc:$old_name:$new_name" >> "$result"
done
echo "DONE\n"
