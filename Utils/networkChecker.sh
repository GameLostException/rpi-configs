#!/bin/bash

IFACE="wlan0"

if [ ! -z "$1" ]
then IFACE="$1"
fi

sudo iftop -B -i $IFACE
