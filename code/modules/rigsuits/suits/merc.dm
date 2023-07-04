/obj/item/clothing/head/helmet/space/hardsuit/merc
	light_overlay = "helmet_light_dual_green"
	camera_networks = list(NETWORK_MERCENARY)

/datum/armor/hardsuit/merc
	melee = 0.8
	bullet = 0.65
	laser = 0.5
	energy = 0.15
	bomb = 0.8
	bio = 1.0
	rad = 0.6

/obj/item/hardsuit/merc
	name = "crimson hardsuit control module"
	desc = "A blood-red hardsuit featuring some fairly illegal technology."
	icon_state = "merc_rig"
	suit_type = "crimson hardsuit"
	armor_type = /datum/armor/hardsuit/merc
	slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = 1
	siemens_coefficient = 0.3
	glove_type = /obj/item/clothing/gloves/gauntlets/hardsuit/eva
	helm_type = /obj/item/clothing/head/helmet/space/hardsuit/merc
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/melee/energy/sword,
		/obj/item/handcuffs,
		/obj/item/storage/backpack,
		/obj/item/bluespace_radio,
	)

	initial_modules = list(
		/obj/item/hardsuit_module/mounted,
		/obj/item/hardsuit_module/vision/thermal,
		/obj/item/hardsuit_module/grenade_launcher,
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/power_sink,
		/obj/item/hardsuit_module/electrowarfare_suite,
		/obj/item/hardsuit_module/chem_dispenser/combat,
		/obj/item/hardsuit_module/fabricator/energy_net
		)

//Has most of the modules removed
/obj/item/hardsuit/merc/empty
	initial_modules = list(
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/electrowarfare_suite, //might as well
		)
