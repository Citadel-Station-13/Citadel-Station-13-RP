#!/bin/bash
set -euo pipefail

md5sum -c - <<< "00088ebae6bf6fdfcb6e2bd40c18f90e *html/changelogs/example.yml"
python3 tools/ss13_genchangelog.py html/changelogs
