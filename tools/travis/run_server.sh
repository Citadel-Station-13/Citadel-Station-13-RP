#!/bin/bash
set -euo pipefail

tools/deploy.sh travis_test
# mkdir travis_test/config deploy builds this because we have to load legacy thing

#test config
# cp tools/travis/travis_config.txt travis_test/config/config.txt\
cp tools/travis/legacy_travis_config.txt travis_test/config/legacy/dbconfig.txt
cp tools/travis/legacy_travis_config.txt travis_test/config/legacy/forumdbconfig.txt
cp tools/travis/legacy_travis_config_2.txt travis_test/config/legacy/config.txt

cd travis_test
ln -s $HOME/libmariadb/libmariadb.so libmariadb.so
DreamDaemon vorestation.dmb -close -trusted -verbose -params "test-run&log-directory=travis"
cd ..
cat travis_test/data/logs/travis/clean_run.lk
