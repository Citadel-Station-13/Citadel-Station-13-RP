/* Make language great again
/datum/design/science/implant/language
	name = "Language implant"
	identifier = "implant_language"
	req_tech = list(TECH_MATERIAL = 5, TECH_BIO = 5, TECH_DATA = 4, TECH_ENGINEERING = 4) //This is not an easy to make implant.
	materials = list(MAT_STEEL = 7000, MAT_GLASS = 7000, MAT_GOLD = 2000, MAT_DIAMOND = 3000)
	build_path = /obj/item/implantcase/vrlanguage
*/
// /datum/design/science/implant/backup
// 	name = "Backup implant"
// 	identifier = "implant_backup"
// 	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2, TECH_DATA = 4, TECH_ENGINEERING = 2)
// 	materials = list(MAT_STEEL = 2000, MAT_GLASS = 2000)
// 	build_path = /obj/item/implantcase/backup

/datum/design/science/weapon/sizegun
	name = "Size gun"
	identifier = "sizegun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 2000, MAT_URANIUM = 2000)
	build_path = /obj/item/gun/energy/sizegun

/datum/design/science/bluespace_jumpsuit
	name = "Bluespace jumpsuit"
	identifier = "bsjumpsuit"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/clothing/under/bluespace

// /datum/design/science/sleevemate
// 	name = "SleeveMate 3700"
// 	identifier = "sleevemate"
// 	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
// 	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
// 	build_path = /obj/item/sleevemate
//
// /datum/design/science/bodysnatcher
// 	name = "Body Snatcher"
// 	identifier = "bodysnatcher"
// 	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 3, TECH_ILLEGAL = 2)
// 	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
// 	build_path = /obj/item/bodysnatcher

/datum/design/science/item/pressureinterlock
	name = "APP pressure interlock"
	identifier = "pressureinterlock"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 250)
	build_path = /obj/item/pressurelock

/datum/design/science/weapon/advparticle
	name = "Advanced anti-particle rifle"
	identifier = "advparticle"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5, TECH_POWER = 3, TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000, MAT_GOLD = 1000, MAT_URANIUM = 750)
	build_path = /obj/item/gun/energy/particle/advanced

/datum/design/science/weapon/particlecannon
	name = "Anti-particle cannon"
	identifier = "particlecannon"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 5, TECH_POWER = 4, TECH_MAGNET = 4)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 1500, MAT_GOLD = 2000, MAT_URANIUM = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/gun/energy/particle/cannon

/datum/design/science/hud/omni
	name = "AR glasses"
	identifier = "omnihud"
	req_tech = list(TECH_MAGNET = 4, TECH_COMBAT = 3, TECH_BIO = 3)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000)
	build_path = /obj/item/clothing/glasses/omnihud

/datum/design/science/translocator
	name = "Personal translocator"
	identifier = "translocator"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_ILLEGAL = 6)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_URANIUM = 4000, MAT_DIAMOND = 2000)
	build_path = /obj/item/perfect_tele

/datum/design/science/nif
	name = "nanite implant framework"
	identifier = "nif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 8000, MAT_URANIUM = 6000, MAT_DIAMOND = 6000)
	build_path = /obj/item/nif

/datum/design/science/nifbio
	name = "bioadaptive NIF"
	identifier = "bioadapnif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5, TECH_BIO = 5)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 15000, MAT_URANIUM = 10000, MAT_DIAMOND = 10000)
	build_path = /obj/item/nif/bioadap
	sort_string = "HABBD" //Changed String from HABBE to HABBD
//Addiing bioadaptive NIF to Protolathe

/datum/design/science/nifrepairtool
	name = "adv. NIF repair tool"
	identifier = "anrt"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials = list(MAT_STEEL = 200, MAT_GLASS = 3000, MAT_URANIUM = 2000, MAT_DIAMOND = 2000)
	build_path = /obj/item/nifrepairer
	sort_string = "HABBE" //Changed String from HABBD to HABBE

// Resleeving Circuitboards

/datum/design/circuit/transhuman_clonepod
	name = "grower pod"
	identifier = "transhuman_clonepod"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/transhuman_clonepod

/datum/design/circuit/transhuman_synthprinter
	name = "SynthFab 3000"
	identifier = "transhuman_synthprinter"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/transhuman_synthprinter

/datum/design/circuit/transhuman_resleever
	name = "Resleeving pod"
	identifier = "transhuman_resleever"
	req_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 4)
	build_path = /obj/item/circuitboard/transhuman_resleever

/datum/design/circuit/resleeving_control
	name = "Resleeving control console"
	identifier = "resleeving_control"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/circuitboard/resleeving_control

/datum/design/circuit/partslathe
	name = "Parts lathe"
	identifier = "partslathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/partslathe

/datum/design/science/weapon/netgun
	name = "\'Retiarius\' capture gun" //cit change
	identifier = "netgun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 3000)
	build_path = /obj/item/gun/energy/netgun

/datum/design/circuit/algae_farm
	name = "Algae Oxygen Generator"
	identifier = "algae_farm"
	req_tech = list(TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/algae_farm

/datum/design/circuit/thermoregulator
	name = "thermal regulator"
	identifier = "thermoregulator"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 3)
	build_path = /obj/item/circuitboard/thermoregulator

/datum/design/circuit/bomb_tester
	name = "Explosive Effect Simulator"
	identifier = "bomb_tester"
	req_tech = list(TECH_PHORON = 3, TECH_DATA = 2, TECH_MAGNET = 2)
	build_path = /obj/item/circuitboard/bomb_tester

/datum/design/circuit/quantum_pad
	name = "Quantum Pad"
	identifier = "quantum_pad"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4, TECH_BLUESPACE = 4)
	build_path = /obj/item/circuitboard/quantumpad

//////Micro mech stuff
/datum/design/circuit/mecha/gopher_main
	name = "'Gopher' central control"
	identifier = "gopher_main"
	build_path = /obj/item/circuitboard/mecha/gopher/main

/datum/design/circuit/mecha/gopher_peri
	name = "'Gopher' peripherals control"
	identifier = "gopher_peri"
	build_path = /obj/item/circuitboard/mecha/gopher/peripherals

/datum/design/circuit/mecha/polecat_main
	name = "'Polecat' central control"
	identifier = "polecat_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/polecat/main

/datum/design/circuit/mecha/polecat_peri
	name = "'Polecat' peripherals control"
	identifier = "polecat_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/polecat/peripherals

/datum/design/circuit/mecha/polecat_targ
	name = "'Polecat' weapon control and targeting"
	identifier = "polecat_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/polecat/targeting

/datum/design/circuit/mecha/weasel_main
	name = "'Weasel' central control"
	identifier = "weasel_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/weasel/main

/datum/design/circuit/mecha/weasel_peri
	name = "'Weasel' peripherals control"
	identifier = "weasel_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/weasel/peripherals

/datum/design/circuit/mecha/weasel_targ
	name = "'Weasel' weapon control and targeting"
	identifier = "weasel_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/weasel/targeting

////// RIGSuit Stuff
/*
/datum/design/science/rig
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 5, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 6000, MAT_URANIUM = 4000)

/datum/design/science/rig/eva
	name = "eva hardsuit (empty)"
	identifier = "eva_hardsuit"
	build_path = /obj/item/rig/eva

/datum/design/science/rig/mining
	name = "industrial hardsuit (empty)"
	identifier = "ind_hardsuit"
	build_path = /obj/item/rig/industrial

/datum/design/science/rig/research
	name = "ami hardsuit (empty)"
	identifier = "ami_hardsuit"
	build_path = /obj/item/rig/hazmat

/datum/design/science/rig/medical
	name = "medical hardsuit (empty)"
	identifier = "med_hardsuit"
	build_path = /obj/item/rig/medical
*/

/datum/design/science/rig_module
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 5, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 4000, MAT_URANIUM = 2000)

/datum/design/science/rig_module/plasma_cutter
	name = "rig module - plasma cutter"
	identifier = "rigmod_plasmacutter"
	build_path = /obj/item/rig_module/device/plasmacutter

/datum/design/science/rig_module/diamond_drill
	name = "rig module - diamond drill"
	identifier = "rigmod_diamonddrill"
	build_path = /obj/item/rig_module/device/drill

/datum/design/science/rig_module/maneuvering_jets
	name = "rig module - maneuvering jets"
	identifier = "rigmod_maneuveringjets"
	build_path = /obj/item/rig_module/maneuvering_jets

/datum/design/science/rig_module/anomaly_scanner
	name = "rig module - anomaly scanner"
	identifier = "rigmod_anomalyscanner"
	build_path = /obj/item/rig_module/device/anomaly_scanner

/datum/design/science/rig_module/orescanner
	name = "rig module - ore scanner"
	identifier = "rigmod_orescanner"
	build_path = /obj/item/rig_module/device/orescanner

/datum/design/science/rig_module/orescanneradv
	name = "rig module - adv. ore scanner"
	identifier = "rigmod_orescanner_adv"
	build_path = /obj/item/rig_module/device/orescanner/advanced
