#!/bin/bash

source /home/pi/Utils/_include.sh
echo -e "$STR_NEW_LINE"

echoWithSingleUnderline "Hard drives:"
df -h | awk  '/sd.1/ {split($6,a,"/"); print a[3] ":\t" $4 "/" $2 " free" }'
echo -e "$STR_NEW_LINE"

echoWithSingleUnderline "Known Media details:"
echo "Movies in Vault: `du -sh "$MOVIES_LOC"`"
echo "Series in Vault: `du -sh "$SERIES_LOC"`"
echo -e "$STR_NEW_LINE"

echoWithSingleUnderline "Pending Media details:"
echo "Medias still downloading: `du -sh "$INCOMPLETE_LOC"`"
echo "Medias downloaded: `du -sh "$COMPLETE_LOC"`"
echo -e "$STR_NEW_LINE"
