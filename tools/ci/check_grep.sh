#!/bin/bash
set -euo pipefail

#nb: must be bash to support shopt globstar
shopt -s globstar

st=0

if git grep -P "\r\n"; then
    echo "ERROR: CRLF line endings detected. Please stop using the webeditor, and fix it using a desktop Git client."
	st = 1
fi;
if grep -El '^\".+\" = \(.+\)' maps/**/*.dmm;	then
    echo "ERROR: Non-TGM formatted map detected. Please convert it using Map Merger!"
    st=1
fi;
if grep -P '^\ttag = \"icon' maps/**/*.dmm;	then
    echo "ERROR: tag vars from icon state generation detected in maps, please remove them."
    st=1
fi;
if grep -P 'step_[xy]' maps/**/*.dmm;	then
    echo "ERROR: step_x/step_y variables detected in maps, please remove them."
    st=1
fi;
if grep -P 'pixel_[^xy]' maps/**/*.dmm;	then
    echo "ERROR: incorrect pixel offset variables detected in maps, please remove them."
    st=1
fi;
#    THE BELOW REQUIRES SMART WIRES
# echo "Checking for cable varedits"
# if grep -P '/obj/structure/cable(/\w+)+\{' maps/**/*.dmm;	then
#     echo "ERROR: vareditted cables detected, please remove them."
#     st=1
# fi;
if grep -P '\td[1-2] =' maps/**/*.dmm;	then
    echo "ERROR: d1/d2 cable variables detected in maps, please remove them."
    st=1
fi;
echo "Checking for stacked cables"
if grep -P '"\w+" = \(\n([^)]+\n)*/obj/structure/cable,\n([^)]+\n)*/obj/structure/cable,\n([^)]+\n)*/area/.+\)' maps/**/*.dmm;	then
    echo "found multiple cables on the same tile, please remove them."
    st=1
fi;
if grep -P '/turf[0-z/_]*,\n/turf' maps/**/*.dmm; then
	echo "FATAL: found multiple tiles on one tile, this will result in severe glitches."
	st=1
fi;
if grep -P '^/area/.+[\{]' maps/**/*.dmm;	then
    echo "ERROR: Vareditted /area path use detected in maps, please replace with proper paths."
    st=1
fi;
if grep -P '\W\/turf\s*[,\){]' maps/**/*.dmm; then
    echo "ERROR: base /turf path use detected in maps, please replace with proper paths."
    st=1
fi;
if grep -P '/turf[a-zA-Z0-9;\s\n_{}/]*,[\n]?/turf' maps/**/*.dmm; then
    echo "ERROR: overlapping /turf's detected in maps, please fix it (do not have more than one /turf in a tile)."
    st=1
fi;
# if grep -P '^/*var/' code/**/*.dm; then
#     echo "ERROR: Unmanaged global var use detected in code, please use the helpers."
#     st=1
# fi;
# echo "Checking for space indentation"
# if grep -P '(^ {2})|(^ [^ * ])|(^    +)' code/**/*.dm; then
#     echo "space indentation detected"
#     st=1
# fi;
# echo "Checking for mixed indentation"
# if grep -P '^\t+ [^ *]' code/**/*.dm; then
#     echo "mixed <tab><space> indentation detected"
#     st=1
# fi;
nl='
'
nl=$'\n'
while read f; do
    t=$(tail -c2 "$f"; printf x); r1="${nl}$"; r2="${nl}${r1}"
    if [[ ! ${t%x} =~ $r1 ]]; then
        echo "file $f is missing a trailing newline"
        st=1
    fi;
done < <(find . -type f -name '*.dm')
# if grep -P '^/[\w/]\S+\(.*(var/|, ?var/.*).*\)' code/**/*.dm; then
#     echo "changed files contains proc argument starting with 'var'"
#     st=1
# fi;
# if grep -i 'centcomm' code/**/*.dm; then
#     echo "ERROR: Misspelling(s) of CENTCOM detected in code, please remove the extra M(s)."
#     st=1
# fi;
# if grep -i 'centcomm' maps/**/*.dmm; then
#     echo "ERROR: Misspelling(s) of CENTCOM detected in maps, please remove the extra M(s)."
#     st=1
# fi;
if grep -ni 'nanotransen' code/**/*.dm; then
    echo "Misspelling(s) of nanotrasen detected in code, please remove the extra N(s)."
    st=1
fi;
if grep -ni 'nanotransen' maps/**/*.dmm; then
    echo "Misspelling(s) of nanotrasen detected in maps, please remove the extra N(s)."
    st=1
fi;
if grep -i '/obj/effect/mapping_helpers/custom_icon' maps/**/*.dmm; then
    echo "Custom icon helper found. Please include dmis as standard assets instead for built-in maps."
    st=1
fi;

exit $st
