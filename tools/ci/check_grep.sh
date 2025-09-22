#!/bin/bash
set -euo pipefail

#nb: must be bash to support shopt globstar
shopt -s globstar extglob

#ANSI Escape Codes for colors to increase contrast of errors
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

st=0

# check for ripgrep
if command -v rg >/dev/null 2>&1; then
	grep=rg
	pcre2_support=1
	if [ ! rg -P '' >/dev/null 2>&1 ] ; then
		pcre2_support=0
	fi
	code_files="code/**/**.dm"
	map_files="maps/**/**.dmm"
	shuttle_map_files="maps/shuttles/**.dmm"
	code_x_515="code/**/!(__byond_version_compat).dm"
else
	pcre2_support=0
	grep=grep
	code_files="-r --include=code/**/**.dm"
	map_files="-r --include=maps/**/**.dmm"
	shuttle_map_files="-r --include=maps/shuttles/**.dmm"
	code_x_515="-r --include=code/**/!(__byond_version_compat).dm"
fi

echo -e "${BLUE}Using grep provider at $(which $grep)${NC}"

part=0
section() {
	echo -e "${BLUE}Checking for $1${NC}..."
	part=0
}

part() {
	part=$((part+1))
	padded=$(printf "%02d" $part)
	echo -e "${GREEN} $padded- $1${NC}"
}


section "map issues"

part "merge conflicts"
if $grep -U '/obj/merge_conflict_marker' $map_files;    then
    echo
    echo -e "${RED}ERROR: Merge conflict markers in maps. Fix it."
	st=1
fi;
part "TGM"
if $grep -U '^".+" = \(.+\)' $map_files;	then
	echo
    echo -e "${RED}ERROR: Non-TGM formatted map detected. Please convert it using Map Merger!${NC}"
    st=1
fi;
part "comments"
if $grep '//' $map_files | $grep -v '//MAP CONVERTED BY dmm2tgm.py THIS HEADER COMMENT PREVENTS RECONVERSION, DO NOT REMOVE' | $grep -v 'name|desc|info'; then # added info, paper uses that
	echo
	echo -e "${RED}ERROR: Unexpected commented out line detected in this map file. Please remove it.${NC}"
	st=1
fi;
part "iconstate tags"
if $grep '^\ttag = "icon' $map_files;	then
	echo
    echo -e "${RED}ERROR: Tag vars from icon state generation detected in maps, please remove them.${NC}"
    st=1
fi;
part "invalid map procs"
if $grep '(new|newlist|icon|matrix|sound)\(.+\)' $map_files;	then
	echo
	echo -e "${RED}ERROR: Using unsupported procs in variables in a map file! Please remove all instances of this.${NC}"
	st=1
fi;
part "common spelling mistakes"
if $grep -i 'nanotransen' $map_files; then
	echo
    echo -e "${RED}ERROR: Misspelling(s) of Nanotrasen detected in maps, please remove the extra N(s).${NC}"
    st=1
fi;
if $grep 'NanoTrasen' $map_files; then
	echo
    echo -e "${RED}ERROR: Misspelling(s) of Nanotrasen detected in maps, please uncapitalize the T(s).${NC}"
    st=1
fi;
if $grep -i'centcomm' $map_files; then
	echo
    echo -e "${RED}ERROR: Misspelling(s) of CentCom detected in maps, please remove the extra M(s).${NC}"
    st=1
fi;
if $grep -i'eciev' $map_files; then
	echo
    echo -e "${RED}ERROR: Common I-before-E typo detected in maps.${NC}"
    st=1
fi;

part "legacy mapping mistakes"
if $grep -P '\td[1-2] =' $map_files; then
	echo
    echo -e "${RED}ERROR: d1/d2 cable variables detected in maps, please remove them.${NC}"
    st=1
fi;
if $grep -P '"\w+" = \(\n([^)]+\n)*/obj/structure/cable,\n([^)]+\n)*/obj/structure/cable,\n([^)]+\n)*/area/.+\)' $map_files; then
    echo
	echo -e "${RED}ERROR: found multiple cables on the same tile, please remove them.${NC}"
    st=1
fi;
if $grep -P '/turf[0-z/_]*,\n/turf' $map_files; then
	echo
	echo -e "${RED}ERROR: found multiple tiles on one tile, this will result in severe glitches.${NC}"
	st=1
fi;
if $grep -P '\W\/turf\s*[,\){]' $map_files; then
    echo
	echo -e "${RED}ERROR: base /turf path use detected in maps, please replace with proper paths.${NC}"
    st=1
fi;
if $grep -P '/turf[a-zA-Z0-9;\s\n_{}/]*,[\n]?/turf' $map_files; then
    echo
	echo -e "${RED}ERROR: overlapping /turf's detected in maps, please fix it (do not have more than one /turf in a tile).${NC}"
    st=1
fi;
if $grep -P '^/area/.+[\{]' $map_files; then
	echo
    echo -e "${RED}ERROR: Vareditted /area path use detected in maps, please replace with proper paths.${NC}"
    st=1
fi;

# section "whitespace issues"
# part "space indentation"
# if $grep '(^ {2})|(^ [^ * ])|(^    +)' $code_files; then
# 	echo
#     echo -e "${RED}ERROR: Space indentation detected, please use tab indentation.${NC}"
#     st=1
# fi;
# part "mixed indentation"
# if $grep '^\t+ [^ *]' $code_files; then
# 	echo
#     echo -e "${RED}ERROR: Mixed <tab><space> indentation detected, please stick to tab indentation.${NC}"
#     st=1
# fi;

section "common mistakes"
# part "global vars"
# if $grep '^/*var/' $code_files; then
# 	echo
# 	echo -e "${RED}ERROR: Unmanaged global var use detected in code, please use the helpers.${NC}"
# 	st=1
# fi;
# part "proc args with var/"
# if $grep '^/[\w/]\S+\(.*(var/|, ?var/.*).*\)' $code_files; then
# 	echo
# 	echo -e "${RED}ERROR: Changed files contains a proc argument starting with 'var'.${NC}"
# 	st=1
# fi;
part "improperly pathed static lists"
if $grep -i 'var/list/static/.*' $code_files; then
	echo
	echo -e "${RED}ERROR: Found incorrect static list definition 'var/list/static/', it should be 'var/static/list/' instead.${NC}"
	st=1
fi;
part "can_perform_action argument check"
if $grep 'can_perform_action\(\s*\)' $code_files; then
	echo
	echo -e "${RED}ERROR: Found a can_perform_action() proc with improper arguments.${NC}"
	st=1
fi;

# TODO reenable this
# part "ensure proper lowertext usage"
# lowertext() is a BYOND-level proc, so it can be used in any sort of code... including the TGS DMAPI which we don't manage in this repository.
# basically, we filter out any results with "tgs" in it to account for this edgecase without having to enforce this rule in that separate codebase.
# grepping the grep results is a bit of a sad solution to this but it's pretty much the only option in our existing linter framework
# if $grep -i 'lowertext\(.+\)' $code_files | $grep -v 'UNLINT\(.+\)' | $grep -v '\/modules\/tgs\/'; then
# 	echo
# 	echo -e "${RED}ERROR: Found a lowertext() proc call. Please use the LOWER_TEXT() macro instead. If you know what you are doing, wrap your text (ensure it is a string) in UNLINT().${NC}"
# 	st=1
# fi;

part "common spelling mistakes"
# one pesky door causing this issue
# if $grep -i 'centcomm' $code_files; then
# 	echo
#     echo -e "${RED}ERROR: Misspelling(s) of CentCom detected in code, please remove the extra M(s).${NC}"
#     st=1
# fi;
if $grep -ni 'nanotransen' $code_files; then
	echo
    echo -e "${RED}ERROR: Misspelling(s) of Nanotrasen detected in code, please remove the extra N(s).${NC}"
    st=1
fi;
if $grep 'NanoTrasen' $code_files; then
	echo
    echo -e "${RED}ERROR: Misspelling(s) of Nanotrasen detected in code, please uncapitalize the T(s).${NC}"
    st=1
fi;
# there is a lot, fixme!
# if $grep -i'eciev' $code_files; then
# 	echo
#     echo -e "${RED}ERROR: Common I-before-E typo detected in code.${NC}"
#     st=1
# fi;

part "updatepaths validity"
missing_txt_lines=$(find tools/UpdatePaths/scripts -type f ! -name "*.txt" | wc -l)
if [ $missing_txt_lines -gt 0 ]; then
    echo
    echo -e "${RED}ERROR: Found an UpdatePaths File that doesn't end in .txt! Please add the proper file extension!${NC}"
    st=1
fi;

section "515 Proc Syntax"
part "proc ref syntax"
if $grep '\.proc/' $code_x_515 ; then
    echo
    echo -e "${RED}ERROR: Outdated proc reference use detected in code, please use proc reference helpers.${NC}"
    st=1
fi;

if [ "$pcre2_support" -eq 1 ]; then
	section "regexes requiring PCRE2"
	part "empty variable values"
	if $grep -PU '{\n\t},' $map_files; then
		echo
		echo -e "${RED}ERROR: Empty variable value list detected in map file. Please remove the curly brackets entirely.${NC}"
		st=1
	fi;
	part "to_chat sanity"
	if $grep -P 'to_chat\((?!.*,).*\)' $code_files; then
		echo
		echo -e "${RED}ERROR: to_chat() missing arguments.${NC}"
		st=1
	fi;
	part "timer flag sanity"
	if $grep -P 'addtimer\((?=.*TIMER_OVERRIDE)(?!.*TIMER_UNIQUE).*\)' $code_files; then
		echo
		echo -e "${RED}ERROR: TIMER_OVERRIDE used without TIMER_UNIQUE.${NC}"
		st=1
	fi
	part "trailing newlines"
	if $grep -PU '[^\n]$(?!\n)' $code_files; then
		echo
		echo -e "${RED}ERROR: File(s) with no trailing newline detected, please add one.${NC}"
		st=1
	fi
	# part "improper atom initialize args"
	# if $grep -P '^/(obj|mob|turf|area|atom)/.+/Initialize\((?!mapload).*\)' $code_files; then
	# 	echo
	# 	echo -e "${RED}ERROR: Initialize override without 'mapload' argument.${NC}"
	# 	st=1
	# fi;
	part "pronoun helper spellcheck"
	if $grep -P '%PRONOUN_(?!they|They|their|Their|theirs|Theirs|them|Them|have|are|were|do|theyve|Theyve|theyre|Theyre|s|es)' $code_files; then
		echo
		echo -e "${RED}ERROR: Invalid pronoun helper found.${NC}"
		st=1
	fi;
else
	echo -e "${RED}pcre2 not supported, skipping checks requiring pcre2"
	echo -e "if you want to run these checks install ripgrep with pcre2 support.${NC}"
fi;

if [ $st = 0 ]; then
    echo
    echo -e "${GREEN}No errors found using $grep!${NC}"
fi;

if [ $st = 1 ]; then
    echo
    echo -e "${RED}Errors found, please fix them and try again.${NC}"
fi;

exit $st
