#!/bin/sh
# Description: add a watermark of the file name to the downloaded wallpaper

green='\e[1;32m%s\e[0m\n'
yellow='\e[1;33m%s\e[0m\n'

# $saveDir is used to set the location where Bing pics of the day
# are stored.  $HOME holds the path of the current user's home directory
saveDir=$HOME'/baidu/bing'

# The file extension for the Bing pic
picExt=".jpg"

# iterate over the Download pictures
for saveFilePath in $saveDir/*$picExt; do

  picName=$(basename $saveFilePath $picExt)
  printf "\nsaveFilePath:"
  printf $saveFilePath
 
  # skip if the file has already been watermarked hence has the "watermarked" prefix in file name 
  if ls $saveFilePath | grep -q "watermarked" > /dev/null; then
    printf "$yellow" " skipped"
    continue;
  fi

  printf "$green" " watermark: $picName"

  ./watermark.sh $saveFilePath force
done

# Exit the script
exit 0
