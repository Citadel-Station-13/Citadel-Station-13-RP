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
		/obj/item/rig_module/basic/mounted,
		/obj/item/rig_module/basic/vision/thermal,
		/obj/item/rig_module/basic/grenade_launcher,
		/obj/item/rig_module/basic/ai_container,
		/obj/item/rig_module/basic/power_sink,
		/obj/item/rig_module/basic/electrowarfare_suite,
		/obj/item/rig_module/basic/chem_dispenser/combat
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

/obj/item/clothing/head/helmet/space/hardsuit/military
	light_overlay = "helmet_light_dual_green"

/obj/item/hardsuit/military/equipped
	initial_modules = list(
		/obj/item/rig_module/basic/mounted/egun,
		/obj/item/rig_module/basic/vision/multi,
		/obj/item/rig_module/basic/grenade_launcher,
		/obj/item/rig_module/basic/ai_container,
		/obj/item/rig_module/basic/power_sink,
		/obj/item/rig_module/basic/electrowarfare_suite,
		/obj/item/rig_module/basic/chem_dispenser/combat,
		)
