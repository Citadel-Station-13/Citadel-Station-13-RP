/obj/item/hardsuit/industrial
	name = "industrial suit control module"
	suit_type = "industrial hardsuit"
	desc = "A heavy, powerful hardsuit used by construction crews and mining corporations."
	icon_state = "engineering_rig"
	armor_type = /datum/armor/hardsuit/industrial
	offline_vision_restriction = 2
	emp_protection = -20
	siemens_coefficient= 0.75
	rigsuit_max_pressure = 15 * ONE_ATMOSPHERE			  // Max pressure the hardsuit protects against when sealed
	rigsuit_min_pressure = 0							  // Min pressure the hardsuit protects against when sealed
	helm_type = /obj/item/clothing/head/helmet/space/hardsuit/industrial

	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/storage/bag/ore,
		/obj/item/t_scanner,
		/obj/item/pickaxe,
		/obj/item/rcd,
		/obj/item/bluespace_radio,
	)

/datum/armor/hardsuit/industrial
	melee = 0.4
	melee_tier = 4.5
	bullet = 0.4
	bullet_tier = 4
	laser = 0.4
	laser_tier = 3.75
	energy = 0.2
	bomb = 0.5
	bio = 1.0
	rad = 0.7

/obj/item/hardsuit/industrial/equipped
	initial_modules = list(
		/obj/item/hardsuit_module/device/plasmacutter,
		/obj/item/hardsuit_module/device/drill,
		/obj/item/hardsuit_module/device/orescanner,
		/obj/item/hardsuit_module/vision/material,
		/obj/item/hardsuit_module/maneuvering_jets,
		)

/obj/item/clothing/head/helmet/space/hardsuit/industrial
	camera_networks = list(NETWORK_MINE)
