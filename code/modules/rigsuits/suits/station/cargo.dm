/obj/item/rig/industrial
	name = "industrial suit control module"
	suit_type = "industrial hardsuit"
	desc = "A heavy, powerful hardsuit used by construction crews and mining corporations."
	icon_state = "engineering_rig"
	r_armor_type = /datum/armor/rig/industrial
	slowdown = 1
	offline_slowdown = 10
	offline_vision_restriction = 2
	emp_protection = -20
	siemens_coefficient= 0.75
	rigsuit_max_pressure = 15 * ONE_ATMOSPHERE			  // Max pressure the rig protects against when sealed
	rigsuit_min_pressure = 0							  // Min pressure the rig protects against when sealed
	helm_type = /obj/item/clothing/head/helmet/space/rig/industrial

	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/storage/bag/ore,
		/obj/item/t_scanner,
		/obj/item/pickaxe,
		/obj/item/rcd,
		/obj/item/storage/backpack,
		/obj/item/bluespace_radio,
	)

/datum/armor/rig/industrial
	melee = 0.6
	bullet = 0.5
	laser = 0.3
	energy = 0.2
	bomb = 0.5
	bio = 1.0
	rad = 0.7

/obj/item/rig/industrial/equipped
	initial_modules = list(
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/vision/material,
		/obj/item/rig_module/maneuvering_jets,
		)

/obj/item/clothing/head/helmet/space/rig/industrial
	camera_networks = list(NETWORK_MINE)
