/datum/prototype/design/science/mechfab/gopher
	abstract_type = /datum/prototype/design/science/mechfab/gopher
	category = "Gopher"
	work = (5 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.

/datum/prototype/design/science/mechfab/gopher/chassis
	name = "Gopher Chassis"
	id = "gopher_chassis"
	build_path = /obj/item/vehicle_chassis/micro/gopher
	work = (3 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 7000)

/datum/prototype/design/science/mechfab/gopher/torso
	name = "Gopher Torso"
	id = "gopher_torso"
	build_path = /obj/item/vehicle_part/micro/gopher_torso
	materials_base = list(MAT_STEEL = 15000, MAT_GLASS = 5250)

/datum/prototype/design/science/mechfab/gopher/left_arm
	name = "Gopher Left Arm"
	id = "gopher_left_arm"
	build_path = /obj/item/vehicle_part/micro/gopher_left_arm
	materials_base = list(MAT_STEEL = 8750)

/datum/prototype/design/science/mechfab/gopher/right_arm
	name = "Gopher Right Arm"
	id = "gopher_right_arm"
	build_path = /obj/item/vehicle_part/micro/gopher_right_arm

	materials_base = list(MAT_STEEL = 8750)

/datum/prototype/design/science/mechfab/gopher/left_leg
	name = "Gopher Left Leg"
	id = "gopher_left_leg"
	build_path = /obj/item/vehicle_part/micro/gopher_left_leg
	materials_base = list(MAT_STEEL = 12500)

/datum/prototype/design/science/mechfab/gopher/right_leg
	name = "Gopher Right Leg"
	id = "gopher_right_leg"
	build_path = /obj/item/vehicle_part/micro/gopher_right_leg
	materials_base = list(MAT_STEEL = 12500)

/datum/prototype/design/science/mecha/drill/micro
	name = "Miniature Drill"
	id = "micro_drill"
	build_path = /obj/item/vehicle_module/tool/drill/micro
	work = (5 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 2500)

/datum/prototype/design/science/mecha/hydraulic_clamp/micro
	name = "Mounted ore box"
	id = "ore_scoop"
	build_path = /obj/item/vehicle_module/tool/micro/orescoop
	work = (5 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 2500)

/datum/prototype/design/science/mechfab/polecat
	abstract_type = /datum/prototype/design/science/mechfab/polecat
	category = "Polecat"
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.

/datum/prototype/design/science/mechfab/polecat/chassis
	name = "Polecat Chassis"
	id = "polecat_chassis"
	build_path = /obj/item/vehicle_chassis/micro/polecat
	work = (3 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 7000)

/datum/prototype/design/science/mechfab/polecat/torso
	name = "Polecat Torso"
	id = "polecat_torso"
	build_path = /obj/item/vehicle_part/micro/polecat_torso
	materials_base = list(MAT_STEEL = 15000, MAT_GLASS = 5250)

/datum/prototype/design/science/mechfab/polecat/left_arm
	name = "Polecat Left Arm"
	id = "polecat_left_arm"
	build_path = /obj/item/vehicle_part/micro/polecat_left_arm
	materials_base = list(MAT_STEEL = 8750)

/datum/prototype/design/science/mechfab/polecat/right_arm
	name = "Polecat Right Arm"
	id = "polecat_right_arm"
	build_path = /obj/item/vehicle_part/micro/polecat_right_arm
	materials_base = list(MAT_STEEL = 8750)

/datum/prototype/design/science/mechfab/polecat/left_leg
	name = "Polecat Left Leg"
	id = "polecat_left_leg"
	build_path = /obj/item/vehicle_part/micro/polecat_left_leg
	materials_base = list(MAT_STEEL = 12500)

/datum/prototype/design/science/mechfab/polecat/right_leg
	name = "Polecat Right Leg"
	id = "polecat_right_leg"
	build_path = /obj/item/vehicle_part/micro/polecat_right_leg
	materials_base = list(MAT_STEEL = 12500)

/datum/prototype/design/science/mechfab/polecat/armour
	name = "Polecat Armour Plates"
	id = "polecat_armour"
	build_path = /obj/item/vehicle_part/micro/polecat_armour
	work = (25 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 12500, MAT_PLASTIC = 7500)

/datum/prototype/design/science/mecha/taser/micro
	name = "\improper TS-12 \"Suppressor\" integrated taser"
	id = "micro_taser"
	build_path = /obj/item/vehicle_module/weapon/energy/microtaser

/datum/prototype/design/science/mecha/weapon/laser/micro
	name = "\improper WS-19 \"Torch\" laser carbine"
	id = "micro_laser"
//	req_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 3)
	build_path = /obj/item/vehicle_module/weapon/energy/microlaser

/datum/prototype/design/science/mecha/weapon/laser_heavy/micro
	name = "\improper PC-20 \"Lance\" light laser cannon"
	id = "micro_laser_heavy"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials_base = list(MAT_STEEL = 10000, MAT_GLASS = 2000, MAT_DIAMOND = 1000)
	build_path = /obj/item/vehicle_module/weapon/energy/laser/microheavy

/datum/prototype/design/science/mecha/weapon/grenade_launcher/micro
	name = "\improper FP-20 mounted grenade launcher"
	id = "micro_flashbang_launcher"
//	req_tech = list(TECH_COMBAT = 3)
	build_path = /obj/item/vehicle_module/weapon/ballistic/missile_rack/grenade/microflashbang

/datum/prototype/design/science/mecha/weapon/scattershot/micro
	name = "\improper Remington C-12 \"Boomstick\""
	desc = "A mounted combat shotgun with integrated ammo-lathe."
	id = "micro_scattershot"
//	req_tech = list(TECH_COMBAT = 4)
	build_path = /obj/item/vehicle_module/weapon/ballistic/microshotgun

/datum/prototype/design/science/mechfab/weasel
	abstract_type = /datum/prototype/design/science/mechfab/weasel
	category = "Weasel"
	work = (5 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.

/datum/prototype/design/science/mechfab/weasel/chassis
	name = "Weasel Chassis"
	id = "weasel_chassis"
	build_path = /obj/item/vehicle_chassis/micro/weasel
	work = (3 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 7000)

/datum/prototype/design/science/mechfab/weasel/torso
	name = "Weasel Torso"
	id = "weasel_torso"
	build_path = /obj/item/vehicle_part/micro/weasel_torso
	materials_base = list(MAT_STEEL = 15000, MAT_GLASS = 5250)

/datum/prototype/design/science/mechfab/weasel/left_arm
	name = "Weasel Left Arm"
	id = "weasel_left_arm"
	build_path = /obj/item/vehicle_part/micro/weasel_left_arm
	materials_base = list(MAT_STEEL = 8750)

/datum/prototype/design/science/mechfab/weasel/right_arm
	name = "Weasel Right Arm"
	id = "weasel_right_arm"
	build_path = /obj/item/vehicle_part/micro/weasel_right_arm
	materials_base = list(MAT_STEEL = 8750)

/datum/prototype/design/science/mechfab/weasel/tri_leg
	name = "Weasel Tri Leg"
	id = "weasel_right_leg"
	build_path = /obj/item/vehicle_part/micro/weasel_tri_leg
	materials_base = list(MAT_STEEL = 27500)

/datum/prototype/design/science/mechfab/weasel/head
	name = "Weasel Head"
	id = "weasel_head"
	build_path = /obj/item/vehicle_part/micro/weasel_head
	materials_base = list(MAT_STEEL = 7000, MAT_GLASS = 2500)

/datum/prototype/design/science/mecha/medigun
	name = "BL-3/P directed restoration system"
	desc = "A portable medical system used to treat external injuries from afar."
	id = "mech_medigun"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_BIO = 6)
	materials_base = list(MAT_STEEL = 9000, MAT_GOLD = 3000, MAT_SILVER = 2750, MAT_DIAMOND = 1500)
	build_path = /obj/item/vehicle_module/weapon/energy/medigun
