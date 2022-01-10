#!/bin/sh
# Description: add a watermark of the file name to the downloaded wallpaper
printf "usage: ./watermark.sh <file_path> <date_of_file> "

  printf " === 1: $1"
  printf " === 2: $2"
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
fileName=$(basename $saveFilePath $picExt)
  printf " === fileName: $fileName, "

# get the date from the file name
date1=$(echo $fileName | sed 's/^\(.*\)\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)\(.*\)$/\2/')
printf "DATE: $date1, "

if [[ $2 == "force" || $fileName != "watermarked."* ]] ; then
 
  printf " === fileName: $fileName, "
  picName=$(echo $fileName | sed 's/^\(watermarked\.\)\(.*\)$/\2/' | sed 's/^\(.*\)\.\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)\(.*\)$/\1/')
  printf " === saveFilePath: $saveFilePath, picName: $picName, "

  # watermark with imagemagick, with file name, install by running "brew install imagemagick"
  # top-left
  # convert $saveFilePath -font Arial -pointsize $pointSize -draw "gravity north \
      #           fill black text -$((x+shadeSize)),1 '$picName' \
      #           fill white text -$x,$((1+shadeSize)) '$picName' \
      #    " $saveFilePath
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
  #convert $saveFilePath -font Arial -pointsize $pointSize -draw "gravity south \
      #           fill black text $((x+shadeSize)),1 '$picName' \
      #           fill white text $x,$((1+shadeSize)) '$picName' \
      #    " $saveFilePath

  # date
  convert $saveFilePath -font Arial -pointsize $pointSize -background '#0008' -draw "gravity south \
                 fill black text -$((x+shadeSize)),1 '$picName $date1' \
                 fill white text -$x,$((1+shadeSize)) '$picName $date1' \
          " $saveFilePath

  # rename the file
  if [[ $fileName != "watermarked."* ]] ; then
    mv $saveFilePath $saveDir/"watermarked."$fileName$picExt
  fi

  printf "$green" " watermarked" 

fi

# Exit the script
exit 0
