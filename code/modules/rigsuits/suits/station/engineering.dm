/obj/item/rig/eva
	name = "EVA suit control module"
	suit_type = "EVA hardsuit"
	desc = "A light hardsuit for repairs and maintenance to the outside of habitats and vessels."
	icon_state = "eva_rig"
	r_armor_type = /datum/armor/rig/eva
	slowdown = 0
	offline_slowdown = 1
	offline_vision_restriction = 1
	siemens_coefficient= 0.75
	seal_delay = 24 //Should be slightly faster than other hardsuits, giving Engineering faster response time for emergencies.


	helm_type = /obj/item/clothing/head/helmet/space/rig/eva
	glove_type = /obj/item/clothing/gloves/gauntlets/rig/eva

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

/datum/armor/rig/eva
	melee = 0.35
	bullet = 0.1
	laser = 0.2
	energy = 0.25
	bomb = 0.45
	bio = 1.0
	rad = 0.95

/obj/item/clothing/gloves/gauntlets/rig/eva
	name = "insulated gauntlets"
	siemens_coefficient = 0

/obj/item/rig/eva/equipped
	initial_modules = list(
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/vision/meson
		)

/obj/item/rig/ce
	name = "advanced voidsuit control module"
	suit_type = "advanced voidsuit"
	desc = "An advanced voidsuit that protects against hazardous, low pressure environments. Shines with a high polish."
	icon_state = "ce_rig"
	r_armor_type = /datum/armor/rig/ce
	slowdown = 0
	offline_slowdown = 0
	offline_vision_restriction = 0
	siemens_coefficient= 0.75
	rigsuit_max_pressure = 20 * ONE_ATMOSPHERE			  // Max pressure the rig protects against when sealed
	rigsuit_min_pressure = 0							  // Min pressure the rig protects against when sealed
	seal_delay = 8 //Why did we give the EVA hardsuit a better equip time than the CE hardsuit, again? I'm changing it.

	helm_type = /obj/item/clothing/head/helmet/space/rig/ce
	glove_type = /obj/item/clothing/gloves/gauntlets/rig/ce
	boot_type = /obj/item/clothing/shoes/magboots/rig/ce

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

/datum/armor/rig/ce
	melee = 0.4
	bullet = 0.2
	laser = 0.3
	energy = 0.25
	bomb = 0.4
	bio = 1.0
	rad = 1.0

/obj/item/clothing/gloves/gauntlets/rig/ce
	name = "insulated gauntlets"
	siemens_coefficient = 0

/obj/item/clothing/shoes/magboots/rig/ce
	slowdown_on = 0

/obj/item/rig/ce/equipped
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/device/rigwelder, // CE gets tools in their RIG
		/obj/item/rig_module/device/toolset
		)
