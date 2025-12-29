#!/bin/bash
set -euo pipefail

tools/deploy.sh ci_test
mkdir -p ci_test/config
mkdir -p ci_test/data

#test config
cp tools/ci/ci_config.txt ci_test/config/config.txt
cp tools/ci/config.toml ci_test/config/config.toml

cd ci_test
DreamDaemon citadel.dmb -close -trusted -verbose -params "log-directory=ci"

cd ..

mkdir -p data/screenshots_new
cp -r ci_test/data/screenshots_new data/screenshots_new
cp ci_test/data/unit_tests.json data/unit_tests.json

cat ci_test/data/logs/ci/clean_run.lk
