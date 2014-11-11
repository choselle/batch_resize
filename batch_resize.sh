#!/bin/bash

cwd=$(pwd)
a=$3
sizeCountOrig=0
sizeCountMod=0

if [ $1 = 'help' ]; then
	echo "Help Page:........................................................................"
	echo "- Compiles script by typing 'chmod +x ./batch_resize.sh'"
	echo "- Use script by typing the command './batch_resize.sh input_dir output_dir ratios."
	echo "- If the output directory already exists, the program will exit."
	echo "- This script will resize all images in the input directory and place them
	in the output directory in the exact format."
	echo "- During the processes and at the end you will get various information about what
	is going on as it happens."

	exit
fi

if [ ! -d $cwd/$2 ]
	then
		mkdir $cwd/$2
	else
		echo "Output directory already exists"
		exit
fi

for dir in $1/*; 
do
	if test -d "$dir"; then
		mkdir $cwd/$2/${dir##*/}
		for i in ${a[@]}; do
			for file in $dir/*.jpg; do
				filename="${file##*/}"
				ext="${filename%.*}"
				convert -resize $i% $file $ext-r$i.jpg;
		
				echo "Original File: "
				echo ${file##*/} | cut -d '.' -f 1
				echo "Original File Size: "
				origFileSize=$(wc -c $file | awk '{print $1;}')
				echo $origFileSize
				let sizeCountOrig+=origFileSize

				echo "Modified file: "
				echo "$ext-r$i"
				echo "Modified File Size: "
				modFileSize=$(wc -c $ext-r$i.jpg | awk '{print $1;}')
				echo $modFileSize
				let sizeCountMod+=modFileSize
		
				mv $ext-r* $cwd/$2/${dir##*/}/.
				let count+=1
				echo ""
			done
		done
	fi
done

echo "Total number of files being processed: "
echo $count
echo "Total size of original files: "
#du -shb $1/ 
echo $sizeCountOrig
echo "Total size of resized files: "
#du -shb $2/ 
echo $sizeCountMod
