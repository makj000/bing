#!/bin/sh
#modified from https://raw.github.com/marguerite/linux-bing-wallpaper/master/bing_wallpaper.sh
# Description: Download Bing Wallpaper of the Day to the same folder
# sample xml url: http://www.bing.com/HPImageArchive.aspx?format=xml&dayAgo=1&n=1&mkt=en-US
# Usage: add the following line in crontab -e
#   40 */5 * * * ~/bin/download_bing_wallpaper.sh

# how many days to go back in history for downloading
daysToGoBack=30

# $bing is needed to form the fully qualified URL for
# the Bing pic of the day
bing="www.bing.com"

# $saveDir is used to set the location where Bing pics of the day
# are stored.  $HOME holds the path of the current user's home directory
saveDir=$HOME'/Pictures/bing'
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

    echo "dayAgo:" $dayAgo "   mkt:" $mkt

    # $xmlURL is needed to get the xml data from which the relative URL for the Bing pic of the day is extracted
    xmlURL="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=$dayAgo&n=1&mkt=$mkt"
    echo "xmlURL:" $xmlURL

    # Extract the relative URL of the Bing pic of the day from the XML data retrieved from xmlURL, form the fully qualified
    # URL for the pic of the day, and store it in $picURL
    #picURIPrefix=$(echo $(curl -s $xmlURL) | grep -oP "<urlBase>(.*)</urlBase>" | cut -d ">" -f 2 | cut -d "<" -f 1)
    picURIPrefix=$(echo $(curl -s "$xmlURL") | grep -ioE "<url>(.*)</url>" | cut -d ">" -f 2 | cut -d "<" -f 1)
    echo "picURIPrefix: " $picURIPrefix
    # stop if the uri is invalid somehow
    if [ "${picURIPrefix}" = "" ]; then
      continue
    fi

    # try from the highest resolution to the lowest resolution, stop at the first successful one
    #for picRes in _1920x1200 _1366x768 _1280x720 _1024x768 
    #do

      #picURI=$picURIPrefix$picRes$picExt
      picURI=$picURIPrefix
      picURL=$bing$picURI
      #echo $picURL
      # exclude resolution and locale from the final local file name to use, since the same picture will show up for different locales and we don't want to end up with multiple files for the same image
      picName=$(echo $picURI | cut -d "/" -f 5 | cut -d "_" -f 1).jpg
      echo -n " " $picName

      # $picName contains the filename of the Bing pic of the day
      #picName=${picURL#*2f}

      # filePath - check if the image to download already exists in the save folder or the archive folder
      saveFilePath=$saveDir/$picName
      echo saveFile: $saveFilePath
      archiveFilePath=$archiveDir/$picName
      if [ -f $saveFilePath -o -f $archiveFilePath ]; then 
        echo -n " file exists already !!"
        continue
      fi
      # Download the Bing pic of the day
      #curl --create-dirs -o $saveFilePath $picURL
      curl -s -o $saveFilePath $picURL

      # Test if it's a pic
      file $saveFilePath | grep HTML && rm -rf $saveFilePath && continue

      # watermark with imagemagick, with file name
      convert $saveFilePath -font Arial -pointsize 20 -draw "gravity south \
                 fill black  text -501,2 '$picName' \
                 fill white  text -500,1 '$picName' \
" $saveFilePath

      #break
    #done

    echo
  done
done

# Exit the script
exit 0
