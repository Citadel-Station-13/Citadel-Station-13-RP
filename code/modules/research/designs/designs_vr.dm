

/datum/prototype/design/science/weapon/sizegun
	design_name = "Size gun"
	id = "RNDDesignSizeGun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials_base = list(MAT_STEEL = 3000, MAT_GLASS = 2000, MAT_URANIUM = 2000)
	build_path = /obj/item/gun/projectile/energy/sizegun

/datum/prototype/design/science/bluespace_jumpsuit
	design_name = "Bluespace jumpsuit"
	id = "RNDDesignBSJumpsuit"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials_base = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/clothing/under/bluespace

/datum/prototype/design/science/item/pressureinterlock
	design_name = "APP pressure interlock"
	id = "RNDDesignAntigunPressureLock"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 1000, MAT_GLASS = 250)
	build_path = /obj/item/pressurelock

/datum/prototype/design/science/weapon/advparticle
	design_name = "Advanced anti-particle rifle"
	id = "RNDDesignAntiRifle"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5, TECH_POWER = 3, TECH_MAGNET = 3)
	materials_base = list(MAT_STEEL = 5000, MAT_GLASS = 1000, MAT_GOLD = 1000, MAT_URANIUM = 750)
	build_path = /obj/item/gun/projectile/energy/particle/advanced

/datum/prototype/design/science/weapon/particlecannon
	design_name = "Anti-particle cannon"
	id = "RNDDesignAntiCannon"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 5, TECH_POWER = 4, TECH_MAGNET = 4)
	materials_base = list(MAT_STEEL = 10000, MAT_GLASS = 1500, MAT_GOLD = 2000, MAT_URANIUM = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/gun/projectile/energy/particle/cannon

/datum/prototype/design/science/hud/omni
	design_name = "AR glasses"
	id = "RNDDesignOmniHud"
	req_tech = list(TECH_MAGNET = 4, TECH_COMBAT = 3, TECH_BIO = 3)
	materials_base = list(MAT_STEEL = 1000, MAT_GLASS = 1000)
	build_path = /obj/item/clothing/glasses/omnihud

/datum/prototype/design/science/translocator
	design_name = "Personal translocator"
	id = "RNDDesignTransloc"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_ILLEGAL = 6)
	materials_base = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_URANIUM = 4000, MAT_DIAMOND = 2000)
	build_path = /obj/item/perfect_tele

// Resleeving Circuitboards

/datum/prototype/design/circuit/transhuman_clonepod
	design_name = "grower pod"
	id = "RNDDesignClonepod"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/transhuman_clonepod

/datum/prototype/design/circuit/transhuman_synthprinter
	design_name = "SynthFab 3000"
	id = "RNDDesignSynthClonePod"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/transhuman_synthprinter

/datum/prototype/design/circuit/transhuman_resleever
	design_name = "Resleeving pod"
	id = "RNDDesignResleever"
	req_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 4)
	build_path = /obj/item/circuitboard/transhuman_resleever

/datum/prototype/design/circuit/resleeving_control
	design_name = "Resleeving control console"
	id = "RNDDesignResleeverConsole"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/circuitboard/resleeving_control

/datum/prototype/design/science/weapon/netgun
	design_name = "\'Retiarius\' capture gun" //cit change
	id = "RNDDesignNetGun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_MAGNET = 3)
	materials_base = list(MAT_STEEL = 6000, MAT_GLASS = 3000)
	build_path = /obj/item/gun/projectile/energy/netgun

/datum/prototype/design/circuit/algae_farm
	design_name = "Algae Oxygen Generator"
	id = "RNDDesignAlgaeOxygenerator"
	req_tech = list(TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/algae_farm

/datum/prototype/design/circuit/thermoregulator
	design_name = "thermal regulator"
	id = "RNDDesignThermalRegulator"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 3)
	build_path = /obj/item/circuitboard/thermoregulator

/datum/prototype/design/circuit/bomb_tester
	design_name = "Explosive Effect Simulator"
	id = "RNDDesignBombTester"
	req_tech = list(TECH_PHORON = 3, TECH_DATA = 2, TECH_MAGNET = 2)
	build_path = /obj/item/circuitboard/bomb_tester

//////Micro mech stuff
/datum/prototype/design/circuit/mecha/gopher_main
	design_name = "'Gopher' central control"
	id = "RNDDesignGopherMainboard"
	build_path = /obj/item/circuitboard/mecha/gopher/main

/datum/prototype/design/circuit/mecha/gopher_peri
	design_name = "'Gopher' peripherals control"
	id = "RNDDesignGopherPeriboard"
	build_path = /obj/item/circuitboard/mecha/gopher/peripherals

/datum/prototype/design/circuit/mecha/polecat_main
	design_name = "'Polecat' central control"
	id = "RNDDesignPolecatMainboard"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/polecat/main

/datum/prototype/design/circuit/mecha/polecat_peri
	design_name = "'Polecat' peripherals control"
	id = "RNDDesignPolecatPeriboard"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/polecat/peripherals

/datum/prototype/design/circuit/mecha/polecat_targ
	design_name = "'Polecat' weapon control and targeting"
	id = "RNDDesignPolecatGunboard"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/polecat/targeting

/datum/prototype/design/circuit/mecha/weasel_main
	design_name = "'Weasel' central control"
	id = "RNDDesignWieselMainboard"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/weasel/main

/datum/prototype/design/circuit/mecha/weasel_peri
	design_name = "'Weasel' peripherals control"
	id = "RNDDesignWieselPeriboard"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/weasel/peripherals

/datum/prototype/design/circuit/mecha/weasel_targ
	design_name = "'Weasel' weapon control and targeting"
	id = "RNDDesignWieselGunboard"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/weasel/targeting

////// RIGSuit Stuff
/*
/datum/prototype/design/science/hardsuit
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 5, TECH_MAGNET = 5)
	materials_base = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 6000, MAT_URANIUM = 4000)

/datum/prototype/design/science/hardsuit/eva
	design_name = "eva hardsuit (empty)"
	id = "eva_hardsuit"
	build_path = /obj/item/hardsuit/eva

/datum/prototype/design/science/hardsuit/mining
	design_name = "industrial hardsuit (empty)"
	id = "ind_hardsuit"
	build_path = /obj/item/hardsuit/industrial

/datum/prototype/design/science/hardsuit/research
	design_name = "ami hardsuit (empty)"
	id = "ami_hardsuit"
	build_path = /obj/item/hardsuit/hazmat

/datum/prototype/design/science/hardsuit/medical
	design_name = "medical hardsuit (empty)"
	id = "med_hardsuit"
	build_path = /obj/item/hardsuit/medical
*/

/datum/prototype/design/science/hardsuit_module
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 5, TECH_MAGNET = 5)
	materials_base = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 4000, MAT_URANIUM = 2000)

/datum/prototype/design/science/hardsuit_module/plasma_cutter
	design_name = "hardsuit module - plasma cutter"
	id = "RNDDesignHardsuitPlasmaCutter"
	build_path = /obj/item/hardsuit_module/device/plasmacutter

/datum/prototype/design/science/hardsuit_module/diamond_drill
	design_name = "hardsuit module - diamond drill"
	id = "RNDDesignHardsuitDiamondDrill"
	build_path = /obj/item/hardsuit_module/device/drill

/datum/prototype/design/science/hardsuit_module/maneuvering_jets
	design_name = "hardsuit module - maneuvering jets"
	id = "RNDDesignHardsuitJetpack"
	build_path = /obj/item/hardsuit_module/maneuvering_jets

/datum/prototype/design/science/hardsuit_module/anomaly_scanner
	design_name = "hardsuit module - anomaly scanner"
	id = "RNDDesignHardsuitAnomScanner"
	build_path = /obj/item/hardsuit_module/device/anomaly_scanner

/datum/prototype/design/science/hardsuit_module/orescanner
	design_name = "hardsuit module - ore scanner"
	id = "RNDDesignHardsuitOreScanner"
	build_path = /obj/item/hardsuit_module/device/orescanner

/datum/prototype/design/science/hardsuit_module/orescanneradv
	design_name = "hardsuit module - adv. ore scanner"
	id = "RNDDesignHardsuitAdvOreScanner"
	build_path = /obj/item/hardsuit_module/device/orescanner/advanced
