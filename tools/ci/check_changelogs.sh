#!/bin/bash
set -euo pipefail

md5sum -c - <<< "b3c430e884433635c0c0f79f85e14b4e *html/changelogs/example.yml"
python3 tools/ss13_genchangelog.py html/changelog.html html/changelogs
