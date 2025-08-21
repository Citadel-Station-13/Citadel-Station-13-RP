//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/rig_theme/species/nepid
	abstract_type = /datum/rig_theme/species/nepid
	base_icon = 'icons/modules/rigsuits/suits/species/nepid.dmi'
	armor = /datum/armor/rigsuit/species/nepid

/datum/armor/rigsuit/species/nepid
	melee = 0.5
	melee_tier = 3
	melee_soak = 0
	melee_deflect = 5
	bullet = 0.15
	bullet_tier = 4.5
	bullet_soak = 0
	bullet_deflect = 5
	laser = 0.25
	laser_tier = 4.5
	laser_soak = 3
	laser_deflect = 0
	energy = 0.225
	bomb = 0.3
	bio = 1.0
	rad = 0.75
	fire = 1.0
	acid = 1.0

DECLARE_RIG_THEME(/species/nepid/generic)
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
	#warn encumbrance
