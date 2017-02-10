# truyền vào một danh sách các file, nếu từ đầu tiên trùng với "Subject:"
# thì in ra dòng đầu tien của file đó

#!/bin/sh
for file in "$@"
do
	while read word1 rest_of_line # dọc dòng đầu tiên (từ thứ 1 tới kí tự kết thúc dòng)
	do
		[ "$word1" = "Subject:" ] && # so sánh từ thứ 1 với "Subject:"
		{
			echo "$file $word1 $rest_of_line";
			break;
		}
	done < $file
done
