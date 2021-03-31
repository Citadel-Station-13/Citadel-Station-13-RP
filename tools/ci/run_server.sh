#!/bin/bash
set -euo pipefail

tools/deploy.sh ci_test
mkdir ci_test/config

#test config
cp tools/ci/ci_config.txt ci_test/config/config.txt

#throw extools into ldd
#cp libbyond-extools.so ~/.byond/bin/libbyond-extools.so
#chmod +x ~/.byond/bin/libbyond-extools.so
#ldd ~/.byond/bin/libbyond-extools.so

# throw rust_g in too
cp rust_g ~/.byond/bin/rust_g
chmod +x ~/.byond/bin/rust_g
ldd ~/.byond/bin/rust_g

cd ci_test
DreamDaemon vorestation.dmb -close -trusted -verbose -params "log-directory=ci"
cd ..
cat ci_test/data/logs/ci/clean_run.lk
