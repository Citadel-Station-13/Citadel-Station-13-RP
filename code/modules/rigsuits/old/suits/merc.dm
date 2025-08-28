/obj/item/clothing/head/helmet/space/hardsuit/merc
	light_overlay = "helmet_light_dual_green"
	camera_networks = list(NETWORK_MERCENARY)

/datum/armor/hardsuit/merc
	melee = 0.5
	melee_tier = 4
	bullet = 0.4
	bullet_tier = 4.5
	laser = 0.5
	laser_tier = 4
	energy = 0.25
	bomb = 0.8
	bio = 1.0
	rad = 0.6
	fire = 0.7
	acid = 1.0

/obj/item/hardsuit/merc
	name = "crimson hardsuit control module"
	desc = "A blood-red hardsuit featuring some fairly illegal technology."
	icon_state = "merc_rig"
	suit_type = "crimson hardsuit"
	armor_type = /datum/armor/hardsuit/merc
	encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_HEAVY
	offline_encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_HEAVY * 2
	siemens_coefficient = 0.3

	initial_modules = list(
		/obj/item/rig_module/basic/mounted,
		/obj/item/rig_module/basic/grenade_launcher,
		/obj/item/rig_module/basic/ai_container,
		/obj/item/rig_module/basic/power_sink,
		/obj/item/rig_module/basic/electrowarfare_suite,
		/obj/item/rig_module/basic/chem_dispenser/combat,
		)

//Has most of the modules removed
/obj/item/hardsuit/merc/empty
	initial_modules = list(
		/obj/item/rig_module/basic/ai_container,
		/obj/item/rig_module/basic/electrowarfare_suite, //might as well
		)
