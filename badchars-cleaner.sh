#!/bin/bash
# Author: Xavi Beltran
# Date: 28/04/2023

# bash badchar-cleaner.sh snfs.list "0x00, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x20"

if [ $# != 2 ]
  then
    echo "BADCHARS GADGET CLEANER
    Usage:
      bash badchars-cleaner.sh gadgets.file "0x00, 0x01, 0x02"
    "
    exit
fi

echo "[+] Process started... "

gadgets_file=$1
badchars=$2

badchars_list=$(echo $badchars | sed 's/0x//g' | sed 's/ //g' | sed 's/,/\n/g')

rm gadgets.temp 2&>/dev/null
rm gadgets.clean 2&>/dev/null
cp $gadgets_file gadgets.temp

for badchar in $badchars_list; do
	echo "[+] Removing badchar: 0x"$badchar
	sed -i '/^0x'"$badchar"'.*$/d' gadgets.temp
	sed -i '/^0x..'"$badchar"'.*$/d' gadgets.temp
	sed -i '/^0x....'"$badchar"'.*$/d' gadgets.temp
	sed -i '/^0x......'"$badchar"'.*$/d' gadgets.temp
done

echo "[+] Sorting gadgets by length... "
cat gadgets.temp | awk '{ print length, $0 }' |sort -n -s |cut -d" " -f2- > gadgets.clean

echo "[+] Process completed. Your file name is: gadgets.clean"
