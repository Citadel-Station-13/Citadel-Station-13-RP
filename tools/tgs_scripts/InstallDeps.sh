#!/bin/bash

#find out what we have (+e is important for this)
set +e
has_git="$(command -v git)"
has_curl="$(command -v curl)"
has_cargo="$(command -v ~/.cargo/bin/cargo)"
has_sudo="$(command -v sudo)"
has_ytdlp="$(command -v yt-dlp)"
has_uv="$(command -v ~/.local/bin/uv)"
has_unzip="$(command -v unzip)"
set -e
set -x

# apt packages, libssl needed by rust-g but not included in TGS barebones install
if ! ( [ -x "$has_git" ] && [ -x "$has_curl" ] && [ -x "$has_uv" ] && [ -x "$has_unzip" ] && [ -f "/usr/lib/i386-linux-gnu/libssl.so" ] ); then
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "!!! HEY YOU THERE, READING THE TGS LOGS READ THIS!!!"
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "We are about to try installing native dependencies, we will use 'sudo' if possible for this, but it may fail because the tgstation-server user doesn't have passwordless sudo."
	echo "WE DO NOT RECOMMEND GRANTING PASSWORDLESS SUDO!!! Instead, install all the dependencies yourself with the following command:"
	echo ".................................................................................................................................................."
	echo "sudo apt-get install -y lib32z1 git pkg-config libssl-dev:i386 libssl-dev zlib1g-dev:i386 curl libclang-dev g++-multilib python3 python3-pip unzip"
	echo ".................................................................................................................................................."
	echo "Attempting to install apt dependencies..."
	if ! [ -x "$has_sudo" ]; then
		dpkg --add-architecture i386
		apt-get update
		apt-get install -y lib32z1 git pkg-config libssl-dev:i386 libssl-dev zlib1g-dev:i386 curl libclang-dev g++-multilib python3 python3-pip unzip
	else
		sudo dpkg --add-architecture i386
		sudo apt-get update
		sudo apt-get install -y lib32z1 git pkg-config libssl-dev:i386 libssl-dev zlib1g-dev:i386 curl libclang-dev g++-multilib python3 python3-pip unzip
	fi
fi

# install cargo if needed
if ! [ -x "$has_cargo" ]; then
	echo "Installing rust..."
	curl https://sh.rustup.rs -sSf | sh -s -- -y
	. ~/.profile
fi

# install or update yt-dlp when not present, or if it is present with uv,
# which we assume was used to install it
if ! [ -x "$has_ytdlp" ]; then
	echo "Installing yt-dlp with uv..."
	~/.local/bin/uv tool install yt-dlp
else
	echo "Ensuring yt-dlp is up-to-date with uv..."
	~/.local/bin/uv tool upgrade yt-dlp
fi
