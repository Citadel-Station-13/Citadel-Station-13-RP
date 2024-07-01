//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/rig_theme/species/nepid
	abstract_type = /datum/rig_theme/species/nepid
	base_icon = 'icons/modules/rigsuits/suits/species/nepid.dmi'
	armor = /datum/armor/rigsuit/species/nepid

/datum/armor/rigsuit/species/nepid
	melee = 0.3
	melee_tier = MELEE_TIER_MEDIUM
	melee_soak = 0
	melee_deflect = 5
	bullet = 0.2
	bullet_tier = BULLET_TIER_MEDIUM
	bullet_soak = 0
	bullet_deflect = 5
	laser = 0.3
	laser_tier = LASER_TIER_MEDIUM
	laser_soak = 3
	laser_deflect = 0
	energy = 0.45
	bomb = 0.3
	bio = 1.0
	rad = 0.75
	fire = 1.0
	acid = 1.0

AUTO_RIG_THEME(/species/nepid/generic)
/**
 * moth EVA harness
 *
 * engineering-capable
 */
/datum/rig_theme/species/nepid/generic
	name = "Dnin-Nepid EVA harness"
	base_state = "generic"
	desc = "A sleek, alien-looking hardsuit worn by nomadic spacefarers."
	fluff_desc = "The standard EVA harness worn by Dnin-Nepids everywhere. Mass produced and stocked aboard practically \
	every Nepid arkship, this piece of equipment has become integral to their ascension to the stars. Fitted with a modest \
	yet usable amount of hardware mounting points, it is the most common piece of equipment used by Nepid \
	explorers."
	display_name = "EVA"
	visible_name = "flight"
	insulated_gloves = TRUE
	siemens_coefficient = 0.5
	max_pressure_protect = ONE_ATMOSPHERE * 11.5
	max_temperature_protect = HEAT_PROTECTION_INDUSTRIAL_VOIDSUIT
	base_weight = 12.5 // uncommonly light for what it is
	offline_encumbrance = 25.5
	online_encumbrance = 17.5
