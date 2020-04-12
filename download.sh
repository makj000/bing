#!/bin/sh
#modified from https://raw.github.com/marguerite/linux-bing-wallpaper/master/bing_wallpaper.sh
# Description: Download Bing Wallpaper of the Day to the same folder
# sample xml url: http://www.bing.com/HPImageArchive.aspx?format=xml&dayAgo=1&n=1&mkt=en-US
# Usage: add the following line in crontab -e
#   40 */5 * * * ~/bin/download.sh

green='\e[1;32m%s\e[0m\n'
yellow='\e[1;33m%s\e[0m\n'

# how many days to go back in history for downloading
daysToGoBack=35

# $bing is needed to form the fully qualified URL for
# the Bing pic of the day
bing="www.bing.com"

# $saveDir is used to set the location where Bing pics of the day
# are stored.  $HOME holds the path of the current user's home directory
saveDir=$HOME'/baidu/bing'
# subfolder for picture archive
archiveDir=$saveDir'/archive'

# Create saveDir if it does not already exist
mkdir -p $saveDir

# The file extension for the Bing pic
picExt=".jpg"

# Download the highest resolution
#while true; do

# Download pictures. The dayAgo parameter determines where to start from. 0 is the current day, 1 the previous day, etc.
for (( dayAgo = 0; dayAgo <= $daysToGoBack; dayAgo++ ));
do

  # The mkt parameter determines which Bing market you would like to
  # obtain your images from.
  # Valid values are: en-US, zh-CN, ja-JP, en-AU, en-UK, de-DE, en-NZ, en-CA.
  # download all locales
  #for mkt in en-US 
  for mkt in en-US zh-CN ja-JP en-AU en-UK de-DE en-NZ en-CA
  # testing one locale
  #for mkt in en-US 
  do
    echo
    printf " === " 
    printf " dayAgo:" 
    printf $dayAgo 
    printf " mkt: " 
    printf $mkt

    # $xmlURL is needed to get the xml data from which the relative URL for the Bing pic of the day is extracted
    xmlURL="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=$dayAgo&n=1&mkt=$mkt"
    printf " xmlURL: "
    printf $xmlURL

    # Extract the relative URL of the Bing pic of the day from the XML data retrieved from xmlURL, form the fully qualified
    # URL for the pic of the day, and store it in $picURL
    #picURIPrefix=$(echo $(curl -s $xmlURL) | grep -oP "<urlBase>(.*)</urlBase>" | cut -d ">" -f 2 | cut -d "<" -f 1)
    picURIPrefix=$(echo $(curl -s "$xmlURL") | grep -ioE "<url>(.*)</url>" | cut -d ">" -f 2 | cut -d "<" -f 1)
    #printf " picURIPrefix: "
    #printf  $picURIPrefix
    # stop if the uri is invalid somehow
    if [ "${picURIPrefix}" = "" ]; then
      continue
    fi

    # try from the highest resolution to the lowest resolution, stop at the first successful one
      printf " --- " 

      #picURI=$picURIPrefix$picRes$picExt
      picURI=$picURIPrefix
      #printf " pic uri: "
      #printf $picURI
      picURL=$bing$picURI
      #printf " pic url: "
      #printf $picURL
      # exclude resolution and locale from the final local file name to use, since the same picture will show up for different locales and we don't want to end up with multiple files for the same image
      picName=$(echo $picURI | cut -d "/" -f 2 | cut -d "_" -f 1 | cut -d "." -f 2).jpg
      #printf "pic name: "
      #printf $picName 

      # $picName contains the filename of the Bing pic of the day
      #picName=${picURL#*2f}

      # filePath - check if the image to download already exists in the save folder or the archive folder
      saveFilePath=$saveDir/$picName
      printf " saveFile: "
      printf $saveFilePath
      archiveFilePath=$archiveDir/$picName
      if [ -f $saveFilePath -o -f $archiveFilePath ]; then 
        printf "$yellow" " file exists already !!"
        continue
      fi
      # Download the Bing pic of the day
      #curl --create-dirs -o $saveFilePath $picURL
      printf "$green" " >>>>> downloading ......"

      # date of the picture
      date1=$(date -v -$((dayAgo))d "+DATE_%Y-%m-%d")
      printf "$green" $date1
      curl -s -o $saveFilePath $picURL

      printf "$green" " <<<<< done" 

      # Test if it's a pic
      file $saveFilePath | grep HTML && rm -rf $saveFilePath && continue

      ./watermark.sh $saveFilePath $date1
  done
done

# Exit the script
exit 0
