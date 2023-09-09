/obj/item/clothing/head/helmet/space/hardsuit/combat
	light_overlay = "helmet_light_dual_green"

/datum/armor/hardsuit/combat
	melee = 0.8
	bullet = 0.65
	laser = 0.5
	energy = 0.25
	bomb = 0.6
	bio = 1.0
	rad = 0.6

/obj/item/hardsuit/combat
	name = "combat hardsuit control module"
	desc = "A sleek and dangerous hardsuit for active combat."
	icon_state = "security_rig"
	suit_type = "combat hardsuit"
	armor_type = /datum/armor/hardsuit/combat
	encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_HEAVY
	offline_encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_HEAVY * 2
	offline_vision_restriction = 1

	helm_type = /obj/item/clothing/head/helmet/space/hardsuit/combat
	allowed = list(
		/obj/item/gun,
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/melee/baton,
		/obj/item/storage/backpack,
		/obj/item/bluespace_radio,
	)


/obj/item/hardsuit/combat/equipped

	initial_modules = list(
		/obj/item/hardsuit_module/mounted,
		/obj/item/hardsuit_module/vision/thermal,
		/obj/item/hardsuit_module/grenade_launcher,
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/power_sink,
		/obj/item/hardsuit_module/electrowarfare_suite,
		/obj/item/hardsuit_module/chem_dispenser/combat
		)

/obj/item/hardsuit/combat/empty
	initial_modules = list(
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/electrowarfare_suite,
		)

/datum/armor/hardsuit/military
	melee = 0.8
	bullet = 0.7
	laser = 0.55
	energy = 0.15
	bomb = 0.8
	bio = 1.0
	rad = 0.3

/obj/item/hardsuit/military
	name = "military hardsuit control module"
	desc = "An austere hardsuit used by paramilitary groups and real soldiers alike."
	icon_state = "military_rig"
	suit_type = "military hardsuit"
	armor_type = /datum/armor/hardsuit/military
	encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_HEAVY
	offline_encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_HEAVY * 2
	offline_vision_restriction = 1
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/handcuffs,
		/obj/item/t_scanner,
		/obj/item/rcd,
		/obj/item/weldingtool,
		/obj/item/tool,
		/obj/item/multitool,
		/obj/item/radio,
		/obj/item/atmos_analyzer,
		/obj/item/storage/briefcase/inflatable,
		/obj/item/melee/baton,
		/obj/item/gun,
		/obj/item/storage/firstaid,
		/obj/item/reagent_containers/hypospray,
		/obj/item/roller,
		/obj/item/suit_cooling_unit,
		/obj/item/storage/backpack,
		/obj/item/bluespace_radio,
	)

	chest_type = /obj/item/clothing/suit/space/hardsuit/military
	helm_type = /obj/item/clothing/head/helmet/space/hardsuit/military
	boot_type = /obj/item/clothing/shoes/magboots/hardsuit/military
	glove_type = /obj/item/clothing/gloves/gauntlets/hardsuit/military

/obj/item/clothing/head/helmet/space/hardsuit/military
	light_overlay = "helmet_light_dual_green"
	species_restricted = list(SPECIES_HUMAN,SPECIES_PROMETHEAN)

/obj/item/clothing/suit/space/hardsuit/military
	species_restricted = list(SPECIES_HUMAN,SPECIES_PROMETHEAN)

/obj/item/clothing/shoes/magboots/hardsuit/military
	species_restricted = list(SPECIES_HUMAN,SPECIES_PROMETHEAN)

/obj/item/clothing/gloves/gauntlets/hardsuit/military
	species_restricted = list(SPECIES_HUMAN,SPECIES_PROMETHEAN)

/obj/item/hardsuit/military/equipped
	initial_modules = list(
		/obj/item/hardsuit_module/mounted/egun,
		/obj/item/hardsuit_module/vision/multi,
		/obj/item/hardsuit_module/grenade_launcher,
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/power_sink,
		/obj/item/hardsuit_module/electrowarfare_suite,
		/obj/item/hardsuit_module/chem_dispenser/combat,
		)

/obj/item/hardsuit/military/empty
	initial_modules = list(
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/electrowarfare_suite,
		)
