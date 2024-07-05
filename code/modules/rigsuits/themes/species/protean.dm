//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

AUTO_RIG_THEME(/species/protean)
/**
 * thin, high tensile strength
 */
/datum/rig_theme/species/protean
	name = "protean rig"
	base_icon = 'icons/modules/rigsuits/suits/species/protean.dmi'
	base_state = "nanosuit"
	desc = "A sleek, form-fitting hardsuit made out of some kind of alloy."
	fluff_desc = "Unlike other hardsuits, this one is missing the usual seams, bolts, and reinforcements. \
	Its motions are unnaturally fluid - the internals are likely not made out of the usual mechanisms."
	display_name = "Nanocluster"
	visible_name = "Sleek"
	insulated_gloves = TRUE
	siemens_coefficient = 0.75
	armor = /datum/armor/rigsuit/species/protean
	max_pressure_protect = ONE_ATMOSPHERE * 11.5
	max_temperature_protect = HEAT_PROTECTION_INDUSTRIAL_VOIDSUIT
	base_weight = 0
	online_encumbrance = 0
	offline_encumbrance = 0

// thin, but resistant against piercing
/datum/armor/rigsuit/species/protean
	melee = 0.05
	melee_soak = 5
	melee_deflect = 5
	melee_tier = MELEE_TIER_HEAVY
	bullet = 0.05
	bullet_deflect = 5
	bullet_tier = BULLET_TIER_HIGH
	laser = 0.075
	laser_deflect = 5
	laser_tier = LASER_TIER_HIGH
	energy = 0.25
	bomb = 0.45
	bio = 1.0
	rad = 0.9
	fire = 1.0
	acid = 1.0
