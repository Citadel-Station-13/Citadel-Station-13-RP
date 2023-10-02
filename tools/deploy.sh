#!/bin/bash

#Run this in the repo root after compiling
#First arg is path to where you want to deploy
#creates a work tree free of everything except what's necessary to run the game

#second arg is working directory if necessary
if [[ $# -eq 2 ]] ; then
  cd $2
fi

mkdir -p \
	$1/_mapload \
    $1/maps \
    $1/icons \
    $1/sound \
    $1/strings \
    $1/tgui/public \
    $1/tgui/packages/tgfont/dist

if [ -d ".git" ]; then
  mkdir -p $1/.git/logs
  cp -r .git/logs/* $1/.git/logs/
fi

cp citadel.dmb citadel.rsc $1/
# mapload: has basemap.dmm, runtime loaded
cp -r _mapload/* $1/_mapload/
# maps: map .dmms and potential assets, runtime loaded
cp -r maps/* $1/maps/
# icons: .dmi assets, runtime loaded
cp -r icons/* $1/icons/
# sounds: .ogg, etc assets, runtime loaded
cp -r sound/* $1/sound/
# strings: .txts, .jsons, runtime loaded
cp -r strings/* $1/strings/
# tgui artifacts: sent to clients, should be present at runtime
cp -r tgui/public/* $1/tgui/public/
# tgfont artifacts: sent to clients, should be present at runtime
cp -r tgui/packages/tgfont/dist/* $1/tgui/packages/tgfont/dist/

#dlls on windows
if [ "$(uname -o)" = "Msys" ]; then
	cp ./*.dll $1/
fi
