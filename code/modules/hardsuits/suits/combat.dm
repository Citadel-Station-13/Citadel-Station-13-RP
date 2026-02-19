/obj/item/clothing/head/helmet/space/hardsuit/combat
	light_overlay = "helmet_light_dual_green"

/datum/armor/hardsuit/combat
	melee = 0.5
	melee_tier = 4
	bullet = 0.45
	bullet_tier = 4
	laser = 0.5
	laser_tier = 4
	energy = 0.25
	bomb = 0.6
	bio = 1.0
	rad = 0.6
	fire = 0.5
	acid = 0.8

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

	chest_type = /obj/item/clothing/suit/space/hardsuit/military
	helm_type = /obj/item/clothing/head/helmet/space/hardsuit/military
	boot_type = /obj/item/clothing/shoes/magboots/hardsuit/military
	glove_type = /obj/item/clothing/gloves/gauntlets/hardsuit/military

/obj/item/clothing/head/helmet/space/hardsuit/military
	light_overlay = "helmet_light_dual_green"

/obj/item/clothing/suit/space/hardsuit/military

/obj/item/clothing/shoes/magboots/hardsuit/military

/obj/item/clothing/gloves/gauntlets/hardsuit/military

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
