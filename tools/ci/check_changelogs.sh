#!/bin/bash
set -euo pipefail

md5sum -c - <<< "4181a1262fd78f1e10c87cf4d691fa90 *html/changelogs/example.yml"
python3 tools/ss13_genchangelog.py html/changelogs
