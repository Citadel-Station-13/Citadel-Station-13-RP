#!/bin/bash
set -euo pipefail

# \/ tg's hash
#"49bc6b1b9ed56c83cceb6674bd97cb34" 
md5sum "html/changelogs/example.yml"
md5sum -c - <<< "88490b460c26947f5ec1ab1bb9fa9f17 *html/changelogs/example.yml"
python3 tools/ss13_genchangelog.py html/changelog.html html/changelogs
