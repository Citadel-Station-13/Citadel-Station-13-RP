//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/rig_theme/station/civilian
	abstract_type = /datum/rig_theme/station/civilian
	base_icon = 'icons/modules/rigsuits/suits/civilian.dmi'

AUTO_RIG_THEME(/station/civilian/standard)
/datum/rig_theme/station/civilian/standard
	name = "standard rig"
	base_state = "standard"
	desc = "A standard-issue civilian hardsuit."
	fluff_desc = "Originally made by inner-system manufacturers in the Orion Confederacy, this design is \
	widely produced by almost every TSC in existence. Cheap and reliable, this lineage of suit is up there \
	on the list of innovations responsible for space travel being as safe as it is today."
	display_name = "standard"
	visible_name = "Standard"
	armor = /datum/armor/rigsuit/station/civilian/standard
	max_temperature_protect = HEAT_PROTECTION_LIGHT_FIRESUIT
	#warn encumbrance

/datum/armor/rigsuit/station/civilian/standard
	melee = 0.15
	melee_tier = MELEE_TIER_MEDIUM
	melee_soak = 0
	melee_deflect = 5
	bullet = 0.15
	bullet_tier = BULLET_TIER_LOW
	bullet_soak = 0
	bullet_deflect = 0
	laser = 0.25
	laser_tier = LASER_TIER_LOW
	laser_soak = 2
	laser_deflect = 2
	energy = 0.25
	bomb = 0.25
	bio = 1.0
	rad = 0.25
	fire = 0.5
	acid = 1.0
