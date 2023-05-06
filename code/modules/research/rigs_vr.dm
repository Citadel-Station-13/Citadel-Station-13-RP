/*
	O - rigsuit stuff
		OA - rigs themselves
		OB - hardsuit modules
			OBAA - general purpose
			OBAB - mining
			OBAC - medical
			OBAD - sec/combat
			OBAE - engineering/maintenance/cleaning
*/


////// RIGSuit Stuff
/*
/datum/design/item/hardsuit
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 5, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 6000, MAT_URANIUM = 4000)

/datum/design/item/hardsuit/AssembleDesignName()
	..()
	name = "hardsuit prototype ([name])"

/datum/design/item/hardsuit/eva
	name = "eva hardsuit (empty)"
	id = "eva_hardsuit"
	build_path = /obj/item/hardsuit/eva
	sort_string = "OAAAA"

/datum/design/item/hardsuit/mining
	name = "industrial hardsuit (empty)"
	id = "ind_hardsuit"
	build_path = /obj/item/hardsuit/industrial
	sort_string = "OAAAB"

/datum/design/item/hardsuit/research
	name = "ami hardsuit (empty)"
	id = "ami_hardsuit"
	build_path = /obj/item/hardsuit/hazmat
	sort_string = "OAAAC"

/datum/design/item/hardsuit/medical
	name = "medical hardsuit (empty)"
	id = "med_hardsuit"
	build_path = /obj/item/hardsuit/medical
	sort_string = "OAAAD"
*/

/datum/design/item/hardsuit_module
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 5, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 4000, MAT_URANIUM = 2000)

/datum/design/item/hardsuit_module/AssembleDesignName()
	..()
	name = "hardsuit module prototype ([name])"

/datum/design/item/hardsuit_module/maneuvering_jets
	name = "maneuvering jets"
	id = "rigmod_maneuveringjets"
	build_path = /obj/item/hardsuit_module/maneuvering_jets
	sort_string = "OBAAA"

/datum/design/item/hardsuit_module/sprinter
	name = "sprinter"
	id = "rigmod_sprinter"
	build_path = /obj/item/hardsuit_module/sprinter
	sort_string = "OBAAB"

/datum/design/item/hardsuit_module/plasma_cutter
	name = "plasma cutter"
	id = "rigmod_plasmacutter"
	build_path = /obj/item/hardsuit_module/device/plasmacutter
	sort_string = "OBABA"

/datum/design/item/hardsuit_module/diamond_drill
	name = "diamond drill"
	id = "rigmod_diamonddrill"
	build_path = /obj/item/hardsuit_module/device/drill
	sort_string = "OBABB"

/datum/design/item/hardsuit_module/anomaly_scanner
	name = "anomaly scanner"
	id = "rigmod_anomalyscanner"
	build_path = /obj/item/hardsuit_module/device/anomaly_scanner
	sort_string = "OBABC"

/datum/design/item/hardsuit_module/orescanner
	name = "ore scanner"
	id = "rigmod_orescanner"
	build_path = /obj/item/hardsuit_module/device/orescanner
	sort_string = "OBABD"

/datum/design/item/hardsuit_module/orescanneradv
	name = "adv. ore scanner"
	id = "rigmod_orescanneradv"
	build_path = /obj/item/hardsuit_module/device/orescanner/advanced
	sort_string = "OBABE"

/datum/design/item/hardsuit_module/rescue_pharm
	name = "rescue pharm"
	id = "rigmod_rescue_pharm"
	build_path = /obj/item/hardsuit_module/rescue_pharm
	sort_string = "OBACA"

/datum/design/item/hardsuit_module/lasercannon
	name = "laser cannon"
	id = "rigmod_lasercannon"
	build_path = /obj/item/hardsuit_module/mounted
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 4000, MAT_URANIUM = 2000, MAT_DIAMOND = 2000)
	sort_string = "OBADA"

/datum/design/item/hardsuit_module/egun
	name = "energy gun"
	id = "rigmod_egun"
	build_path = /obj/item/hardsuit_module/mounted/egun
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 4000, MAT_URANIUM = 2000, MAT_DIAMOND = 1000)
	sort_string = "OBADB"

/datum/design/item/hardsuit_module/taser
	name = "taser"
	id = "rigmod_taser"
	build_path = /obj/item/hardsuit_module/mounted/taser
	sort_string = "OBADC"

/datum/design/item/hardsuit_module/armblade
	name = "arm-mounted blade"
	id = "rigmod_armblade"
	build_path = /obj/item/hardsuit_module/armblade
	sort_string = "OBADD"
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 2000, MAT_SILVER = 2000, MAT_GOLD = 2000)

/datum/design/item/hardsuit_module/rcd
	name = "rcd"
	id = "rigmod_rcd"
	build_path = /obj/item/hardsuit_module/device/rcd
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 4000, MAT_URANIUM = 2000, MAT_DIAMOND = 2000)
	sort_string = "OBAEA"

/datum/design/item/hardsuit_module/rigwelder
	name = "hardsuit arc-welder"
	id = "rigmod_welder"
	build_path = /obj/item/hardsuit_module/device/rigwelder
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 4000, MAT_SILVER = 2000, MAT_GOLD = 4000)
	sort_string = "OBAEB"

/datum/design/item/hardsuit_module/toolset
	name = "hardsuit toolset"
	id = "rigmod_tools"
	build_path = /obj/item/hardsuit_module/device/toolset
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 2000, MAT_SILVER = 2000, MAT_PLASTEEL = 1000)
	sort_string = "OBAEC"
