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

	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/datum/armor/hardsuit/eva
	melee = 0.35
	melee_tier = 3.75
	bullet = 0.075
	bullet_tier = 3.75
	laser = 0.2
	laser_tier = 4
	energy = 0.45
	bomb = 0.65
	bio = 1.0
	rad = 0.95
	fire = 1.0
	acid = 1.0

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
	name = "advanced hardsuit control module"
	suit_type = "advanced hardsuit"
	desc = "An advanced hardsuit that protects against hazardous, low pressure environments. Shines with a high polish."
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

	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/datum/armor/hardsuit/ce
	melee_tier = 4.1
	bullet_tier = 4.1
	laser_tier = 4.3
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
