#!/bin/bash
set -e
source dependencies.sh

echo "Downloading BYOND version $BYOND_MAJOR.$BYOND_MINOR"
DOWNLOAD_URL="http://www.byond.com/download/build/$BYOND_MAJOR/$BYOND_MAJOR.${BYOND_MINOR}_byond.zip"
echo "Download URL: $DOWNLOAD_URL"

curl --fail -L "$DOWNLOAD_URL" -o C:/byond.zip -A "Citadel-Station-13-RP/1.0 Continuous Integration"
