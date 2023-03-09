/datum/design/science/mechfab/gopher
	category = list("Gopher")
	work = (5 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.

/datum/design/science/mechfab/gopher/chassis
	name = "Gopher Chassis"
	identifier = "gopher_chassis"
	build_path = /obj/item/mecha_parts/micro/chassis/gopher
	work = (3 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 7000)

/datum/design/science/mechfab/gopher/torso
	name = "Gopher Torso"
	identifier = "gopher_torso"
	build_path = /obj/item/mecha_parts/micro/part/gopher_torso
	materials = list(MAT_STEEL = 15000, MAT_GLASS = 5250)

/datum/design/science/mechfab/gopher/left_arm
	name = "Gopher Left Arm"
	identifier = "gopher_left_arm"
	build_path = /obj/item/mecha_parts/micro/part/gopher_left_arm
	materials = list(MAT_STEEL = 8750)

/datum/design/science/mechfab/gopher/right_arm
	name = "Gopher Right Arm"
	identifier = "gopher_right_arm"
	build_path = /obj/item/mecha_parts/micro/part/gopher_right_arm

	materials = list(MAT_STEEL = 8750)

/datum/design/science/mechfab/gopher/left_leg
	name = "Gopher Left Leg"
	identifier = "gopher_left_leg"
	build_path = /obj/item/mecha_parts/micro/part/gopher_left_leg
	materials = list(MAT_STEEL = 12500)

/datum/design/science/mechfab/gopher/right_leg
	name = "Gopher Right Leg"
	identifier = "gopher_right_leg"
	build_path = /obj/item/mecha_parts/micro/part/gopher_right_leg
	materials = list(MAT_STEEL = 12500)

/datum/design/science/mecha/drill/micro
	name = "Miniature Drill"
	identifier = "micro_drill"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill/micro
	work = (5 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 2500)

/datum/design/science/mecha/hydraulic_clamp/micro
	name = "Mounted ore box"
	identifier = "ore_scoop"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/micro/orescoop
	work = (5 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 2500)

/datum/design/science/mechfab/polecat
	category = list("Polecat")
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.

/datum/design/science/mechfab/polecat/chassis
	name = "Polecat Chassis"
	identifier = "polecat_chassis"
	build_path = /obj/item/mecha_parts/micro/chassis/polecat
	work = (3 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 7000)

/datum/design/science/mechfab/polecat/torso
	name = "Polecat Torso"
	identifier = "polecat_torso"
	build_path = /obj/item/mecha_parts/micro/part/polecat_torso
	materials = list(MAT_STEEL = 15000, MAT_GLASS = 5250)

/datum/design/science/mechfab/polecat/left_arm
	name = "Polecat Left Arm"
	identifier = "polecat_left_arm"
	build_path = /obj/item/mecha_parts/micro/part/polecat_left_arm
	materials = list(MAT_STEEL = 8750)

/datum/design/science/mechfab/polecat/right_arm
	name = "Polecat Right Arm"
	identifier = "polecat_right_arm"
	build_path = /obj/item/mecha_parts/micro/part/polecat_right_arm
	materials = list(MAT_STEEL = 8750)

/datum/design/science/mechfab/polecat/left_leg
	name = "Polecat Left Leg"
	identifier = "polecat_left_leg"
	build_path = /obj/item/mecha_parts/micro/part/polecat_left_leg
	materials = list(MAT_STEEL = 12500)

/datum/design/science/mechfab/polecat/right_leg
	name = "Polecat Right Leg"
	identifier = "polecat_right_leg"
	build_path = /obj/item/mecha_parts/micro/part/polecat_right_leg
	materials = list(MAT_STEEL = 12500)

/datum/design/science/mechfab/polecat/armour
	name = "Polecat Armour Plates"
	identifier = "polecat_armour"
	build_path = /obj/item/mecha_parts/micro/part/polecat_armour
	work = (25 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 12500, MAT_PLASTIC = 7500)

/datum/design/science/mecha/taser/micro
	name = "\improper TS-12 \"Suppressor\" integrated taser"
	identifier = "micro_taser"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/microtaser

/datum/design/science/mecha/weapon/laser/micro
	name = "\improper WS-19 \"Torch\" laser carbine"
	identifier = "micro_laser"
//	req_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/microlaser

/datum/design/science/mecha/weapon/laser_heavy/micro
	name = "\improper PC-20 \"Lance\" light laser cannon"
	identifier = "micro_laser_heavy"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 2000, MAT_DIAMOND = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/microheavy

/datum/design/science/mecha/weapon/grenade_launcher/micro
	name = "\improper FP-20 mounted grenade launcher"
	identifier = "micro_flashbang_launcher"
//	req_tech = list(TECH_COMBAT = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/microflashbang

/datum/design/science/mecha/weapon/scattershot/micro
	name = "\improper Remington C-12 \"Boomstick\""
	desc = "A mounted combat shotgun with integrated ammo-lathe."
	identifier = "micro_scattershot"
//	req_tech = list(TECH_COMBAT = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/microshotgun

/datum/design/science/mechfab/weasel
	category = list("Weasel")
	work = (5 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.

/datum/design/science/mechfab/weasel/chassis
	name = "Weasel Chassis"
	identifier = "weasel_chassis"
	build_path = /obj/item/mecha_parts/micro/chassis/weasel
	work = (3 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 7000)

/datum/design/science/mechfab/weasel/torso
	name = "Weasel Torso"
	identifier = "weasel_torso"
	build_path = /obj/item/mecha_parts/micro/part/weasel_torso
	materials = list(MAT_STEEL = 15000, MAT_GLASS = 5250)

/datum/design/science/mechfab/weasel/left_arm
	name = "Weasel Left Arm"
	identifier = "weasel_left_arm"
	build_path = /obj/item/mecha_parts/micro/part/weasel_left_arm
	materials = list(MAT_STEEL = 8750)

/datum/design/science/mechfab/weasel/right_arm
	name = "Weasel Right Arm"
	identifier = "weasel_right_arm"
	build_path = /obj/item/mecha_parts/micro/part/weasel_right_arm
	materials = list(MAT_STEEL = 8750)

/*/datum/design/science/mechfab/weasel/left_leg
	name = "Weasel Left Leg"
	identifier = "weasel_left_leg"
	build_path = /obj/item/mecha_parts/micro/part/weasel_left_leg
	materials = list(MAT_STEEL = 12500)

/datum/design/science/mechfab/weasel/right_leg
	name = "Weasel Right Leg"
	identifier = "weasel_right_leg"
	build_path = /obj/item/mecha_parts/micro/part/weasel_right_leg
	materials = list(MAT_STEEL = 12500)*/

/datum/design/science/mechfab/weasel/tri_leg
	name = "Weasel Tri Leg"
	identifier = "weasel_right_leg"
	build_path = /obj/item/mecha_parts/micro/part/weasel_tri_leg
	materials = list(MAT_STEEL = 27500)

/datum/design/science/mechfab/weasel/head
	name = "Weasel Head"
	identifier = "weasel_head"
	build_path = /obj/item/mecha_parts/micro/part/weasel_head
	materials = list(MAT_STEEL = 7000, MAT_GLASS = 2500)

/datum/design/science/mecha/medigun
	name = "BL-3/P directed restoration system"
	desc = "A portable medical system used to treat external injuries from afar."
	identifier = "mech_medigun"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_BIO = 6)
	materials = list(MAT_STEEL = 9000, MAT_GOLD = 3000, MAT_SILVER = 2750, MAT_DIAMOND = 1500)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/medigun
