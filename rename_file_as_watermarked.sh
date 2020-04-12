#!/bin/sh
# Description: add a watermark of the file name to the downloaded wallpaper

green='\e[1;32m%s\e[0m\n'
yellow='\e[1;33m%s\e[0m\n'

# The file extension for the Bing pic
picExt=".jpg"

# x-axis location of watermarks
x=500
# how large is the shade of the watermarks (eg. 1, 2)
shadeSize=2

# iterate over the Download pictures
#for saveFilePath in $saveDir/*$picExt; do

saveFilePath=$1
saveDir=$(dirname $saveFilePath)
picName=$(basename $saveFilePath $picExt)
if [[ $picName != "watermarked."* ]] ; then
  
  echo
  printf " === " 
  printf " saveFilePath:"
  printf $saveFilePath
  printf " picName:" 
  printf $picName

  mv $saveFilePath $saveDir/"watermarked."$picName$picExt
  printf "$green" " <<<<< watermarked" 

fi

# Exit the script
exit 0
