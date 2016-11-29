#!/bin/sh

DMENU="dmenu -i"

WALLPAPER_DIR="/home/xtonousou/pictures/wallpapers"
WALLPAPER=`ls $WALLPAPER_DIR \
	| $DMENU -p "Choose a Wallpaper :"`

FEH="hsetroot -fill"

$FEH $WALLPAPER_DIR/$WALLPAPER
