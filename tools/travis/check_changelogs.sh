#!/bin/bash
set -euo pipefail

md5sum -c - <<< "4af85ad64b1761a2db1226809459c984 *html/changelogs/example.yml"
python3 tools/ss13_genchangelog.py html/changelog.html html/changelogs
