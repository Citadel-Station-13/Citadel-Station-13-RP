//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

var/global/list/ALL_ANTIGENS = list(
		"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
	)

/legacy_hook/startup/proc/randomise_antigens_order()
	ALL_ANTIGENS = shuffle(ALL_ANTIGENS)
	return 1

// iterate over the list of antigens and see what matches
/proc/antigens2string(list/antigens, none="None")
	if(!istype(antigens))
		CRASH("Illegal type!")
	if(!antigens.len)
		return none

	var/code = ""
	for(var/V in ALL_ANTIGENS)
		if(V in antigens)
			code += V

	if(!code)
		return none

	return code


var/list/all_antigens = list(
	"ANTIGEN_O",
	"ANTIGEN_A",
	"ANTIGEN_B",
	"ANTIGEN_RH",
	"ANTIGEN_Q",
	"ANTIGEN_U",
	"ANTIGEN_V",
	"ANTIGEN_M",
	"ANTIGEN_N",
	"ANTIGEN_P",
	"ANTIGEN_X",
	"ANTIGEN_Y",
	"ANTIGEN_Z",
	//"ANTIGEN_CULT" i don't think we want cult antigens/antibodies
)

var/list/blood_antigens = list(
	"ANTIGEN_O",
	"ANTIGEN_A",
	"ANTIGEN_B",
	"ANTIGEN_RH",
)

var/list/common_antigens = list(
	"ANTIGEN_Q",
	"ANTIGEN_U",
	"ANTIGEN_V",
)

var/list/rare_antigens = list(
	"ANTIGEN_M",
	"ANTIGEN_N",
	"ANTIGEN_P",
)

var/list/alien_antigens = list(
	"ANTIGEN_X",
	"ANTIGEN_Y",
	"ANTIGEN_Z",
)

//var/list/special_antigens = list(
//	"ANTIGEN_CULT",
//)
///i dunno what this does since it isn't called in anywhere else i saw
/*/proc/antigen_family(var/id)
	switch(id)
		if (ANTIGEN_BLOOD)
			return blood_antigens
		if (ANTIGEN_COMMON)
			return common_antigens
		if (ANTIGEN_RARE)
			return rare_antigens
		if (ANTIGEN_ALIEN)
			return alien_antigens
		if(ANTIGEN_SPECIAL)
			return special_antigens
*/
