#!/shellscript
# Script to say hello

if [ $# -ne 1 ]
then
	printf "Usage: ./hello <name>\n"
	exit
fi
printf "Hello, %s!\n" "$1"
