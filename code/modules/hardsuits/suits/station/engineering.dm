/obj/item/hardsuit/eva
	name = "EVA suit control module"
	suit_type = "EVA hardsuit"
	desc = "A light hardsuit for repairs and maintenance to the outside of habitats and vessels."
	icon_state = "eva_rig"
	armor_type = /datum/armor/hardsuit/eva
	encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_LIGHT
	offline_encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_LIGHT * 2
	offline_vision_restriction = 1
	siemens_coefficient= 0.75
	seal_delay = 24 //Should be slightly faster than other hardsuits, giving Engineering faster response time for emergencies.


	helm_type = /obj/item/clothing/head/helmet/space/hardsuit/eva
	glove_type = /obj/item/clothing/gloves/gauntlets/hardsuit/eva

	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/storage/backpack,
		/obj/item/storage/briefcase/inflatable,
		/obj/item/t_scanner,
		/obj/item/rcd
		)

	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/datum/armor/hardsuit/eva
	melee = 0.35
	bullet = 0.1
	laser = 0.2
	energy = 0.25
	bomb = 0.45
	bio = 1.0
	rad = 0.95

/obj/item/clothing/gloves/gauntlets/hardsuit/eva
	name = "insulated gauntlets"
	siemens_coefficient = 0

/obj/item/hardsuit/eva/equipped
	initial_modules = list(
		/obj/item/hardsuit_module/device/plasmacutter,
		/obj/item/hardsuit_module/maneuvering_jets,
		/obj/item/hardsuit_module/device/rcd,
		/obj/item/hardsuit_module/vision/meson
		)

/obj/item/clothing/head/helmet/space/hardsuit/eva
	light_overlay = "helmet_light_dual"
	camera_networks = list(NETWORK_ENGINEERING)

/obj/item/hardsuit/ce
	name = "advanced voidsuit control module"
	suit_type = "advanced voidsuit"
	desc = "An advanced voidsuit that protects against hazardous, low pressure environments. Shines with a high polish."
	icon_state = "ce_rig"
	armor_type = /datum/armor/hardsuit/ce
	encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_LIGHT
	offline_encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_LIGHT * 2
	offline_vision_restriction = 0
	siemens_coefficient= 0.75
	rigsuit_max_pressure = 20 * ONE_ATMOSPHERE			  // Max pressure the hardsuit protects against when sealed
	rigsuit_min_pressure = 0							  // Min pressure the hardsuit protects against when sealed
	seal_delay = 8 //Why did we give the EVA hardsuit a better equip time than the CE hardsuit, again? I'm changing it.

	helm_type = /obj/item/clothing/head/helmet/space/hardsuit/ce
	glove_type = /obj/item/clothing/gloves/gauntlets/hardsuit/ce
	boot_type = /obj/item/clothing/shoes/magboots/hardsuit/ce

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

	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/datum/armor/hardsuit/ce
	melee = 0.4
	bullet = 0.2
	laser = 0.3
	energy = 0.25
	bomb = 0.4
	bio = 1.0
	rad = 1.0

/obj/item/clothing/gloves/gauntlets/hardsuit/ce
	name = "insulated gauntlets"
	siemens_coefficient = 0

/obj/item/clothing/shoes/magboots/hardsuit/ce
	encumbrance_on = ITEM_ENCUMBRANCE_SHOES_MAGBOOTS_PULSE_ADVANCED

/obj/item/hardsuit/ce/equipped
	initial_modules = list(
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/maneuvering_jets,
		/obj/item/hardsuit_module/device/plasmacutter,
		/obj/item/hardsuit_module/device/rcd,
		/obj/item/hardsuit_module/vision/meson,
		/obj/item/hardsuit_module/device/rigwelder, // CE gets tools in their hardsuit
		/obj/item/hardsuit_module/device/toolset
		)

/obj/item/clothing/head/helmet/space/hardsuit/ce
	camera_networks = list(NETWORK_ENGINEERING,NETWORK_COMMAND)
