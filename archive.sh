#!/bin/sh
#modified from https://raw.github.com/marguerite/linux-bing-wallpaper/master/bing_wallpaper.sh
# Description: Remove old Bing Wallpaper of the Day to the same folder
# Usage: add the following line in crontab -e
#   20 10 */15 * * ~/<path>/archive.sh

# how many days to keep the pictures for 
numToKeep=30

# $saveDir is used to set the location where Bing pics of the day
# are stored.  $HOME holds the path of the current user's home directory
saveDir=$HOME'/Pictures/bing'

# subfolder for picture archive
archiveDir=$saveDir'/000_archive'
mkdir -p $archiveDir

# Archive pictures
numOfFiles=`ls $saveDir | wc -l`
echo 'numOfFiles: ' $numOfFiles
#numToArchive=`expr $numOfFiles - $numToKeep`
declare -i numToArchive
numToArchive="$numOfFiles - $numToKeep"
echo 'numToArchive: ' $numToArchive

if [ $numToArchive -gt 0 ]; then
  echo "Archiving $saveDir files..."
  # take action on each file. $f store current file name
  for f in `ls -rt $saveDir | head -$numToArchive`
  do
    fullPath=$saveDir/$f
    echo $fullPath
    mv $fullPath $archiveDir
  done
fi

notify-send "archiving wallpapers done :)"
