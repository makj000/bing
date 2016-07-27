#!/bin/sh
#modified from https://raw.github.com/marguerite/linux-bing-wallpaper/master/bing_wallpaper.sh
# Description: Download Bing Wallpaper of the Day to the same folder
# sample xml url: http://www.bing.com/HPImageArchive.aspx?format=xml&idx=$idx&n=1&mkt=$mkt

# $bing is needed to form the fully qualified URL for
# the Bing pic of the day
bing="www.bing.com"

# $saveDir is used to set the location where Bing pics of the day
# are stored.  $HOME holds the path of the current user's home directory
saveDir=$HOME'/Pictures/bing/'

# Create saveDir if it does not already exist
mkdir -p $saveDir

# The file extension for the Bing pic
picExt=".jpg"

# Download the highest resolution
#while true; do

# The mkt parameter determines which Bing market you would like to
# obtain your images from.
# Valid values are: en-US, zh-CN, ja-JP, en-AU, en-UK, de-DE, en-NZ, en-CA.
for mkt in en-US zh-CN ja-JP en-AU en-UK de-DE en-NZ en-CA
do

  # The idx parameter determines where to start from. 0 is the current day,
  # 1 the previous day, etc.
  for idx in 0 .. 20 
  do

    # $xmlURL is needed to get the xml data from which
    # the relative URL for the Bing pic of the day is extracted
    xmlURL="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=$idx&n=1&mkt=$mkt"

    # Extract the relative URL of the Bing pic of the day from
    # the XML data retrieved from xmlURL, form the fully qualified
    # URL for the pic of the day, and store it in $picURL
    picURIPrefix=$(echo $(curl -s $xmlURL) | grep -oP "<urlBase>(.*)</urlBase>" | cut -d ">" -f 2 | cut -d "<" -f 1)
    echo "picURIPrefix: " $picURIPrefix
    if [ "${picURIPrefix}" = "" ]; then
      break
    fi

    for picRes in _1920x1200 _1366x768 _1280x720 _1024x768 
    do

      picURI=$picURIPrefix$picRes$picExt
      picURL=$bing$picURI
      echo $picURL
      picName=$(echo $picURI | cut -d "/" -f 5)

      # $picName contains the filename of the Bing pic of the day
      #picName=${picURL#*2f}

      # Download the Bing pic of the day
      curl --create-dirs -o $saveDir$picName $picURL

      # Test if it's a pic
      file $saveDir$picName | grep HTML && rm -rf $saveDir$picName && continue

      break
    done
  done
done

# Exit the script
exit 0
