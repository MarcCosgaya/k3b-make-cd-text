#!/bin/bash

if [ ! $# -eq 1 ]; then
	echo "Use: $0 <project file>"
	exit 1
fi

# unzip and remove original project
unzip $1
rm $1

# fill artist and song arrays
names=$(grep "^<file" maindata.xml)
k=0
while read ln; do 
    full_song=`echo "$ln" | rev | cut -d '/' -f 2 | cut -d '.' -f 2 | rev`

    artist=$(cut -d " - " -f 1 <<< "$full_song" | xargs -0)
    #artist="${artist##*( )}"

    song=$(cut -d " - " -f 2 <<< "$full_song" | xargs -0)
    #song="${song%%*( )}"

    songs[$k]="$song"
    artists[$k]="$artist"
    k=$((k+1))
done <<< "$names"

# iterate through maindata.xml and modify title and artist lines
i=0
j=0
c=0
d=0
while read ln; do
    if [[ $ln == \<title* ]]; then
        if [[ c -eq 0 ]]; then
            c=1
            dir=${PWD##*/}
            dir=${dir:-/}
            echo "<title>$dir</title>" >> maindata-temp.xml
        else
            res="$( echo ${songs[$i]} )"
            echo "<title>$res</title>" >> maindata-temp.xml
            i=$((i+1))
        fi
    elif [[ $ln == \<artist* ]]; then
        if [[ d -eq 0 ]]; then
            d=1
            echo $ln >> maindata-temp.xml
        else
            res="$( echo ${artists[$j]} )"
            echo "<artist>$res</artist>" >> maindata-temp.xml
            j=$((j+1))
        fi
    else
        echo $ln >> maindata-temp.xml
    fi
done < maindata.xml

# cleanup
rm maindata.xml
mv maindata-temp.xml maindata.xml
zip $1 maindata.xml mimetype
rm maindata.xml mimetype
