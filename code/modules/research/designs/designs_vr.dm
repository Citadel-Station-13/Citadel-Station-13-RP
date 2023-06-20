/* Make language great again
/datum/design/science/implant/language
	design_name = "Language implant"
	id = "implant_language"
	req_tech = list(TECH_MATERIAL = 5, TECH_BIO = 5, TECH_DATA = 4, TECH_ENGINEERING = 4) //This is not an easy to make implant.
	materials = list(MAT_STEEL = 7000, MAT_GLASS = 7000, MAT_GOLD = 2000, MAT_DIAMOND = 3000)
	build_path = /obj/item/implantcase/vrlanguage
*/
// /datum/design/science/implant/backup
// 	design_name = "Backup implant"
// 	id = "implant_backup"
// 	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2, TECH_DATA = 4, TECH_ENGINEERING = 2)
// 	materials = list(MAT_STEEL = 2000, MAT_GLASS = 2000)
// 	build_path = /obj/item/implantcase/backup

/datum/design/science/weapon/sizegun
	design_name = "Size gun"
	id = "sizegun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 2000, MAT_URANIUM = 2000)
	build_path = /obj/item/gun/energy/sizegun

/datum/design/science/bluespace_jumpsuit
	design_name = "Bluespace jumpsuit"
	id = "bsjumpsuit"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/clothing/under/bluespace

// /datum/design/science/sleevemate
// 	design_name = "SleeveMate 3700"
// 	id = "sleevemate"
// 	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
// 	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
// 	build_path = /obj/item/sleevemate
//
// /datum/design/science/bodysnatcher
// 	design_name = "Body Snatcher"
// 	id = "bodysnatcher"
// 	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 3, TECH_ILLEGAL = 2)
// 	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
// 	build_path = /obj/item/bodysnatcher

/datum/design/science/item/pressureinterlock
	design_name = "APP pressure interlock"
	id = "pressureinterlock"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 250)
	build_path = /obj/item/pressurelock

/datum/design/science/weapon/advparticle
	design_name = "Advanced anti-particle rifle"
	id = "advparticle"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5, TECH_POWER = 3, TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000, MAT_GOLD = 1000, MAT_URANIUM = 750)
	build_path = /obj/item/gun/energy/particle/advanced

/datum/design/science/weapon/particlecannon
	design_name = "Anti-particle cannon"
	id = "particlecannon"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 5, TECH_POWER = 4, TECH_MAGNET = 4)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 1500, MAT_GOLD = 2000, MAT_URANIUM = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/gun/energy/particle/cannon

/datum/design/science/hud/omni
	design_name = "AR glasses"
	id = "omnihud"
	req_tech = list(TECH_MAGNET = 4, TECH_COMBAT = 3, TECH_BIO = 3)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000)
	build_path = /obj/item/clothing/glasses/omnihud

/datum/design/science/translocator
	design_name = "Personal translocator"
	id = "translocator"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_ILLEGAL = 6)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_URANIUM = 4000, MAT_DIAMOND = 2000)
	build_path = /obj/item/perfect_tele

/datum/design/science/nif
	design_name = "nanite implant framework"
	id = "nif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 8000, MAT_URANIUM = 6000, MAT_DIAMOND = 6000)
	build_path = /obj/item/nif

/datum/design/science/nifbio
	design_name = "bioadaptive NIF"
	id = "bioadapnif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5, TECH_BIO = 5)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 15000, MAT_URANIUM = 10000, MAT_DIAMOND = 10000)
	build_path = /obj/item/nif/bioadap
//Addiing bioadaptive NIF to Protolathe

/datum/design/science/nifrepairtool
	design_name = "adv. NIF repair tool"
	id = "anrt"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials = list(MAT_STEEL = 200, MAT_GLASS = 3000, MAT_URANIUM = 2000, MAT_DIAMOND = 2000)
	build_path = /obj/item/nifrepairer

// Resleeving Circuitboards

/datum/design/circuit/transhuman_clonepod
	design_name = "grower pod"
	id = "transhuman_clonepod"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/transhuman_clonepod

/datum/design/circuit/transhuman_synthprinter
	design_name = "SynthFab 3000"
	id = "transhuman_synthprinter"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/transhuman_synthprinter

/datum/design/circuit/transhuman_resleever
	design_name = "Resleeving pod"
	id = "transhuman_resleever"
	req_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 4)
	build_path = /obj/item/circuitboard/transhuman_resleever

/datum/design/circuit/resleeving_control
	design_name = "Resleeving control console"
	id = "resleeving_control"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/circuitboard/resleeving_control

/datum/design/circuit/partslathe
	design_name = "Parts lathe"
	id = "partslathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/partslathe

/datum/design/science/weapon/netgun
	design_name = "\'Retiarius\' capture gun" //cit change
	id = "netgun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 3000)
	build_path = /obj/item/gun/energy/netgun

/datum/design/circuit/algae_farm
	design_name = "Algae Oxygen Generator"
	id = "algae_farm"
	req_tech = list(TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/algae_farm

/datum/design/circuit/thermoregulator
	design_name = "thermal regulator"
	id = "thermoregulator"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 3)
	build_path = /obj/item/circuitboard/thermoregulator

/datum/design/circuit/bomb_tester
	design_name = "Explosive Effect Simulator"
	id = "bomb_tester"
	req_tech = list(TECH_PHORON = 3, TECH_DATA = 2, TECH_MAGNET = 2)
	build_path = /obj/item/circuitboard/bomb_tester

//////Micro mech stuff
/datum/design/circuit/mecha/gopher_main
	design_name = "'Gopher' central control"
	id = "gopher_main"
	build_path = /obj/item/circuitboard/mecha/gopher/main

/datum/design/circuit/mecha/gopher_peri
	design_name = "'Gopher' peripherals control"
	id = "gopher_peri"
	build_path = /obj/item/circuitboard/mecha/gopher/peripherals

/datum/design/circuit/mecha/polecat_main
	design_name = "'Polecat' central control"
	id = "polecat_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/polecat/main

/datum/design/circuit/mecha/polecat_peri
	design_name = "'Polecat' peripherals control"
	id = "polecat_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/polecat/peripherals

/datum/design/circuit/mecha/polecat_targ
	design_name = "'Polecat' weapon control and targeting"
	id = "polecat_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/polecat/targeting

/datum/design/circuit/mecha/weasel_main
	design_name = "'Weasel' central control"
	id = "weasel_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/weasel/main

/datum/design/circuit/mecha/weasel_peri
	design_name = "'Weasel' peripherals control"
	id = "weasel_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/weasel/peripherals

/datum/design/circuit/mecha/weasel_targ
	design_name = "'Weasel' weapon control and targeting"
	id = "weasel_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/weasel/targeting

////// RIGSuit Stuff
/*
/datum/design/science/hardsuit
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 5, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 6000, MAT_URANIUM = 4000)

/datum/design/science/hardsuit/eva
	design_name = "eva hardsuit (empty)"
	id = "eva_hardsuit"
	build_path = /obj/item/hardsuit/eva

/datum/design/science/hardsuit/mining
	design_name = "industrial hardsuit (empty)"
	id = "ind_hardsuit"
	build_path = /obj/item/hardsuit/industrial

/datum/design/science/hardsuit/research
	design_name = "ami hardsuit (empty)"
	id = "ami_hardsuit"
	build_path = /obj/item/hardsuit/hazmat

/datum/design/science/hardsuit/medical
	design_name = "medical hardsuit (empty)"
	id = "med_hardsuit"
	build_path = /obj/item/hardsuit/medical
*/

/datum/design/science/hardsuit_module
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 5, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 4000, MAT_URANIUM = 2000)

/datum/design/science/hardsuit_module/plasma_cutter
	design_name = "hardsuit module - plasma cutter"
	id = "hardsuitmod_plasmacutter"
	build_path = /obj/item/hardsuit_module/device/plasmacutter

/datum/design/science/hardsuit_module/diamond_drill
	design_name = "hardsuit module - diamond drill"
	id = "hardsuitmod_diamonddrill"
	build_path = /obj/item/hardsuit_module/device/drill

/datum/design/science/hardsuit_module/maneuvering_jets
	design_name = "hardsuit module - maneuvering jets"
	id = "hardsuitmod_maneuveringjets"
	build_path = /obj/item/hardsuit_module/maneuvering_jets

/datum/design/science/hardsuit_module/anomaly_scanner
	design_name = "hardsuit module - anomaly scanner"
	id = "hardsuitmod_anomalyscanner"
	build_path = /obj/item/hardsuit_module/device/anomaly_scanner

/datum/design/science/hardsuit_module/orescanner
	design_name = "hardsuit module - ore scanner"
	id = "hardsuitmod_orescanner"
	build_path = /obj/item/hardsuit_module/device/orescanner

/datum/design/science/hardsuit_module/orescanneradv
	design_name = "hardsuit module - adv. ore scanner"
	id = "hardsuitmod_orescanner_adv"
	build_path = /obj/item/hardsuit_module/device/orescanner/advanced
