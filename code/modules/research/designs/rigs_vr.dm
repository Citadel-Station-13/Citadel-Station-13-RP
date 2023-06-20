/*
	O - hardsuitsuit stuff
		OA - hardsuits themselves
		OB - hardsuit modules
			OBAA - general purpose
			OBAB - mining
			OBAC - medical
			OBAD - sec/combat
			OBAE - engineering/maintenance/cleaning
*/


////// RIGSuit Stuff
/*
/datum/design/science/hardsuit
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 5, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 6000, MAT_URANIUM = 4000)

/datum/design/science/hardsuit/AssembleDesignName()
	..()
	name = "hardsuit prototype ([name])"

/datum/design/science/hardsuit/eva
	name = "eva hardsuit (empty)"
	id = "eva_hardsuit"
	build_path = /obj/item/hardsuit/eva

/datum/design/science/hardsuit/mining
	name = "industrial hardsuit (empty)"
	id = "ind_hardsuit"
	build_path = /obj/item/hardsuit/industrial

/datum/design/science/hardsuit/research
	name = "ami hardsuit (empty)"
	id = "ami_hardsuit"
	build_path = /obj/item/hardsuit/hazmat

/datum/design/science/hardsuit/medical
	name = "medical hardsuit (empty)"
	id = "med_hardsuit"
	build_path = /obj/item/hardsuit/medical
*/

/datum/design/science/hardsuit_module
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 5, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 4000, MAT_URANIUM = 2000)

/datum/design/science/hardsuit_module/generate_name(template)
	return "hardsuit module prototype ([..()])"

/datum/design/science/hardsuit_module/maneuvering_jets
	name = "maneuvering jets"
	id = "hardsuitmod_maneuveringjets"
	build_path = /obj/item/hardsuit_module/maneuvering_jets

/datum/design/science/hardsuit_module/sprinter
	name = "sprinter"
	id = "hardsuitmod_sprinter"
	build_path = /obj/item/hardsuit_module/sprinter

/datum/design/science/hardsuit_module/plasma_cutter
	name = "plasma cutter"
	id = "hardsuitmod_plasmacutter"
	build_path = /obj/item/hardsuit_module/device/plasmacutter

/datum/design/science/hardsuit_module/diamond_drill
	name = "diamond drill"
	id = "hardsuitmod_diamonddrill"
	build_path = /obj/item/hardsuit_module/device/drill

/datum/design/science/hardsuit_module/anomaly_scanner
	name = "anomaly scanner"
	id = "hardsuitmod_anomalyscanner"
	build_path = /obj/item/hardsuit_module/device/anomaly_scanner

/datum/design/science/hardsuit_module/orescanner
	name = "ore scanner"
	id = "hardsuitmod_orescanner"
	build_path = /obj/item/hardsuit_module/device/orescanner

/datum/design/science/hardsuit_module/orescanneradv
	name = "adv. ore scanner"
	id = "hardsuitmod_orescanneradv"
	build_path = /obj/item/hardsuit_module/device/orescanner/advanced

/datum/design/science/hardsuit_module/rescue_pharm
	name = "rescue pharm"
	id = "hardsuitmod_rescue_pharm"
	build_path = /obj/item/hardsuit_module/rescue_pharm

/datum/design/science/hardsuit_module/lasercannon
	name = "laser cannon"
	id = "hardsuitmod_lasercannon"
	build_path = /obj/item/hardsuit_module/mounted
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 4000, MAT_URANIUM = 2000, MAT_DIAMOND = 2000)

/datum/design/science/hardsuit_module/egun
	name = "energy gun"
	id = "hardsuitmod_egun"
	build_path = /obj/item/hardsuit_module/mounted/egun
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 4000, MAT_URANIUM = 2000, MAT_DIAMOND = 1000)

/datum/design/science/hardsuit_module/taser
	name = "taser"
	id = "hardsuitmod_taser"
	build_path = /obj/item/hardsuit_module/mounted/taser

/datum/design/science/hardsuit_module/armblade
	name = "arm-mounted blade"
	id = "hardsuitmod_armblade"
	build_path = /obj/item/hardsuit_module/armblade
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 2000, MAT_SILVER = 2000, MAT_GOLD = 2000)

/datum/design/science/hardsuit_module/rcd
	name = "rcd"
	id = "hardsuitmod_rcd"
	build_path = /obj/item/hardsuit_module/device/rcd
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 4000, MAT_URANIUM = 2000, MAT_DIAMOND = 2000)

/datum/design/science/hardsuit_module/hardsuitwelder
	name = "RIG arc-welder"
	id = "hardsuitmod_welder"
	build_path = /obj/item/hardsuit_module/device/rigwelder
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 4000, MAT_SILVER = 2000, MAT_GOLD = 4000)

/datum/design/science/hardsuit_module/toolset
	name = "RIG toolset"
	id = "hardsuitmod_tools"
	build_path = /obj/item/hardsuit_module/device/toolset
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 2000, MAT_SILVER = 2000, MAT_PLASTEEL = 1000)
