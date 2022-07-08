#!/bin/sh
# Description: add a watermark of the file name to the downloaded wallpaper

green='\e[1;32m%s\e[0m\n'
yellow='\e[1;33m%s\e[0m\n'

# $saveDir is used to set the location where Bing pics of the day
# are stored.  $HOME holds the path of the current user's home directory
saveDir=$HOME'/baidu/bing/to-rename-to-unwatermarked'

# The file extension for the Bing pic
picExt=".jpg"

# iterate over the Download pictures
for saveFilePath in $saveDir/*$picExt; do

  picName=$(basename $saveFilePath $picExt)
  
  echo
  printf " === " 
  printf " saveFilePath:"
  printf $saveFilePath
  printf " picName:" 
  printf $picName

  ./rename_file_as_unwatermarked.sh $saveFilePath
done

# Exit the script
exit 0
