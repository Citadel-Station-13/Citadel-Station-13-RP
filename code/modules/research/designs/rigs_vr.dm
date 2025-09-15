/datum/prototype/design/science/hardsuit_module
	abstract_type = /datum/prototype/design/science/hardsuit_module
	category = DESIGN_CATEGORY_HARDSUIT
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 5, TECH_MAGNET = 5)
	materials_base = list(MAT_STEEL = 850, MAT_GLASS = 750, MAT_SILVER = 750, MAT_URANIUM = 750)

/datum/prototype/design/science/hardsuit_module/generate_name(template)
	return "hardsuit module prototype ([..()])"

/datum/prototype/design/science/hardsuit_module/maneuvering_jets
	design_name = "maneuvering jets"
	id = "hardsuitmod_maneuveringjets"
	build_path = /obj/item/hardsuit_module/maneuvering_jets

/datum/prototype/design/science/hardsuit_module/sprinter
	design_name = "sprinter"
	id = "hardsuitmod_sprinter"
	build_path = /obj/item/hardsuit_module/sprinter

/datum/prototype/design/science/hardsuit_module/plasma_cutter
	design_name = "plasma cutter"
	id = "hardsuitmod_plasmacutter"
	build_path = /obj/item/hardsuit_module/device/plasmacutter

/datum/prototype/design/science/hardsuit_module/diamond_drill
	design_name = "diamond drill"
	id = "hardsuitmod_diamonddrill"
	build_path = /obj/item/hardsuit_module/device/drill

/datum/prototype/design/science/hardsuit_module/anomaly_scanner
	design_name = "anomaly scanner"
	id = "hardsuitmod_anomalyscanner"
	build_path = /obj/item/hardsuit_module/device/anomaly_scanner

/datum/prototype/design/science/hardsuit_module/orescanner
	design_name = "ore scanner"
	id = "hardsuitmod_orescanner"
	build_path = /obj/item/hardsuit_module/device/orescanner

/datum/prototype/design/science/hardsuit_module/orescanneradv
	design_name = "adv. ore scanner"
	id = "hardsuitmod_orescanneradv"
	build_path = /obj/item/hardsuit_module/device/orescanner/advanced

/datum/prototype/design/science/hardsuit_module/rescue_pharm
	design_name = "rescue pharm"
	id = "hardsuitmod_rescue_pharm"
	build_path = /obj/item/hardsuit_module/rescue_pharm

/datum/prototype/design/science/hardsuit_module/lasercannon
	design_name = "laser cannon"
	id = "hardsuitmod_lasercannon"
	build_path = /obj/item/hardsuit_module/mounted
	materials_base = list(MAT_STEEL = 1500, MAT_GLASS = 1500, MAT_SILVER = 2000, MAT_URANIUM = 2000, MAT_DIAMOND = 2000)

/datum/prototype/design/science/hardsuit_module/egun
	design_name = "energy gun"
	id = "hardsuitmod_egun"
	build_path = /obj/item/hardsuit_module/mounted/egun
	materials_base = list(MAT_STEEL = 1500, MAT_GLASS = 1500, MAT_SILVER = 1500, MAT_URANIUM = 750, MAT_DIAMOND = 350)

/datum/prototype/design/science/hardsuit_module/taser
	design_name = "taser"
	id = "hardsuitmod_taser"
	build_path = /obj/item/hardsuit_module/mounted/taser

/datum/prototype/design/science/hardsuit_module/armblade
	design_name = "arm-mounted blade"
	id = "hardsuitmod_armblade"
	build_path = /obj/item/hardsuit_module/armblade
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 350, MAT_SILVER = 150, MAT_GOLD = 250)

/datum/prototype/design/science/hardsuit_module/rcd
	design_name = "rcd"
	id = "hardsuitmod_rcd"
	build_path = /obj/item/hardsuit_module/device/rcd
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 750, MAT_URANIUM = 350, MAT_DIAMOND = 500)

/datum/prototype/design/science/hardsuit_module/hardsuitwelder
	design_name = "RIG arc-welder"
	id = "hardsuitmod_welder"
	build_path = /obj/item/hardsuit_module/device/rigwelder
	materials_base = list(MAT_STEEL = 250, MAT_GLASS = 750, MAT_SILVER = 250, MAT_GOLD = 250)

/datum/prototype/design/science/hardsuit_module/toolset
	design_name = "RIG toolset"
	id = "hardsuitmod_tools"
	build_path = /obj/item/hardsuit_module/device/toolset
	materials_base = list(MAT_STEEL = 750, MAT_GLASS = 750, MAT_SILVER = 250, MAT_PLASTEEL = 250)
