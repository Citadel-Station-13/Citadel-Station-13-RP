#!/usr/bin/env bash
set -euo pipefail

source dependencies.sh

if [ -d "~/flyway/flyway-$FLYWAY_VERSION" ]; then
	echo "Using cached flyway $FLYWAY_VERSION."
else
	echo "Pulling flyway $FLYWAY_VERSION."
	rm -rf ~/flyway/flyway-$FLYWAY_VERSION
	mkdir -p ~/flyway
	cd ~/flyway
	curl "https://download.red-gate.com/maven/release/com/redgate/flyway/flyway-commandline/$FLYWAY_VERSION/flyway-commandline-$FLYWAY_VERSION-linux-x64.tar.gz" | tar -xvz
	cd ~
fi
