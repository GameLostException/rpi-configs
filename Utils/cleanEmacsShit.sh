#!/bin/bash

DEL_FLAG="-delete"

# If we have the -i option, just search but don't delete
if [ ! -z "$1" ] && [ "$1" == "-i" ]
then
    DEL_FLAG=""
fi

sudo find /lib /usr /etc /home -type f \( -name "*~" -o -name "#*#" \) $DEL_FLAG
