#!/bin/sh
# Description: add a watermark of the file name to the downloaded wallpaper

green='\e[1;32m%s\e[0m\n'
yellow='\e[1;33m%s\e[0m\n'

# earliest date to go back to for renaming, don't rename files with dates marked before this date
earliestDate="20220708"
#earliest_date_sec=$(date -jf "%y%m%d" "220709")
#printf "earliest_date_sec: " || earliest_date_sec


# The file extension for the Bing pic
picExt=".jpg"

# iterate over the Download pictures
#for saveFilePath in $saveDir/*$picExt; do

saveFilePath=$1
  #printf "\n saveFilePath: $saveFilePath"
saveDir=$(dirname $saveFilePath)
  #printf "\n saveDir: $saveDir"
picName=$(basename $saveFilePath $picExt)
  #printf "\n picName: $picName"
  
if [[ $picName = "watermarked."* ]] ; then
#  dateStr="$(echo $picName | awk -F. '{ print $3 }' )"
#  printf " dateStr: " 
#  printf $dateStr
#  date_sec=$(date -j -f "%Y-%m-%d" $dateStr "+%s")
#  printf " date_sec: " || $date_sec
#  ((diff_sec=date_sec-earliest_date_sec))
#  ((diff_day=diff_sec/60/60/24))
#  echo "diff in days: " + $diff_day

  echo
  printf "   === saveFilePath: $saveFilePath"

  newFileName="$(echo $picName | awk -F. '{print $2"."$3".jpg"}')"
  #printf "\n newFileName: $newFileName"

  mv $saveFilePath $saveDir/$newFileName
  printf "$green" "   <<<<< renamed to unwatermarked" 

fi

# Exit the script
exit 0
