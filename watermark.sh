#!/bin/sh
# Description: add a watermark of the file name to the downloaded wallpaper
# usage: ./watermark.sh <file_path> <date_of_file>

green='\e[1;32m%s\e[0m\n'
yellow='\e[1;33m%s\e[0m\n'

# $saveDir is used to set the location where Bing pics of the day
# are stored.  $HOME holds the path of the current user's home directory
saveDir=$HOME'/baidu/bing'

# The file extension for the Bing pic
picExt=".jpg"

# x-axis location of watermarks
x=500
# how large is the shade of the watermarks (eg. 1, 2)
shadeSize=2
# font size of watermarks
pointSize=20

# iterate over the Download pictures
#for saveFilePath in $saveDir/*$picExt; do

saveFilePath=$1
picName=$(basename $saveFilePath $picExt)
if [[ $picName != "watermarked."* ]] ; then
  
  echo
  printf " === " 
  printf " saveFilePath:"
  printf $saveFilePath
  printf " picName:" 
  printf $picName

  # watermark with imagemagick, with file name, install by running "brew install imagemagick"
  # top-left
  convert $saveFilePath -font Arial -pointsize $pointSize -draw "gravity north \
                 fill black text -$((x+shadeSize)),1 '$picName' \
                 fill white text -$x,$((1+shadeSize)) '$picName' \
          " $saveFilePath
  # top-right
  #convert $saveFilePath -font Arial -pointsize $pointSize -draw "gravity north \
      #           fill black text $((x+shadeSize)),1 '$picName' \
      #           fill white text $x,$((1+shadeSize)) '$picName' \
      #    " $saveFilePath
  # bottom-left
  #convert $saveFilePath -font Arial -pointsize $pointSize -draw "gravity south \
      #           fill black text -$((x+shadeSize)),1 '$picName' \
      #           fill white text -$x,$((1+shadeSize)) '$picName' \
      #    " $saveFilePath
  # bottom-right
  convert $saveFilePath -font Arial -pointsize $pointSize -draw "gravity south \
      #           fill black text $((x+shadeSize)),1 '$picName' \
      #           fill white text $x,$((1+shadeSize)) '$picName' \
      #    " $saveFilePath

  # date
  if [ ! -z "$2" ] ; then
  printf " exists $2 "
  convert $saveFilePath -font Arial -pointsize $pointSize -draw "gravity south \
                 fill black text -$((x+shadeSize)),1 "$2" \
                 fill white text -$x,$((1+shadeSize)) "$2" \
          " $saveFilePath
  fi

  # rename the file
  mv $saveFilePath $saveDir/"watermarked."$picName$picExt

  printf "$green" " <<<<< watermarked" 

fi

# Exit the script
exit 0
