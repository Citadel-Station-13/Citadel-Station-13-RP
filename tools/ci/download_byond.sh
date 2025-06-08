#!/bin/bash
set -e
source dependencies.sh

echo "Downloading BYOND version $BYOND_MAJOR.$BYOND_MINOR"
curl -H "User-Agent: citadelstation/1.0 CI Script" "http://www.byond.com/download/build/$BYOND_MAJOR/$BYOND_MAJOR.${BYOND_MINOR}_byond.zip" -o C:/byond.zip
