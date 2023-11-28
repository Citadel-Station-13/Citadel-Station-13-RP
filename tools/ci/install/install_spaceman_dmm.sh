#!/bin/bash
## This script installs SpacemanDMM
## It will be linked to the provided filename (argument 1), in the user's home directory
## todo: is this good behavior? should we standardize the location somewhere?

set -euo pipefail

source dependencies.sh

if [ ! -f ~/$1 ]; then
	mkdir -p "$HOME/SpacemanDMM"
	CACHEFILE="$HOME/SpacemanDMM/$1"

	if ! [ -f "$CACHEFILE.version" ] || ! grep -Fxq "$SPACEMAN_DMM_VERSION" "$CACHEFILE.version"; then
		wget -O "$CACHEFILE" "https://github.com/SpaceManiac/SpacemanDMM/releases/download/$SPACEMAN_DMM_VERSION/$1"
		chmod +x "$CACHEFILE"
		echo "$SPACEMAN_DMM_VERSION" >"$CACHEFILE.version"
	fi

	ln -s "$CACHEFILE" ~/$1
fi

~/$1 --version
