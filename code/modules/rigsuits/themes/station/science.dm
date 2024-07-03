//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/armor/rigsuit/station/science
	melee = 0.15
	melee_tier = MELEE_TIER_MEDIUM
	melee_soak = 0
	melee_deflect = 5
	bullet = 0.15
	bullet_tier = BULLET_TIER_MEDIUM
	bullet_soak = 0
	bullet_deflect = 3
	laser = 0.15
	laser_tier = LASER_TIER_HIGH
	laser_soak = 0
	laser_deflect = 5
	energy = 0.45
	bomb = 0.75
	bio = 1.0
	rad = 1.0
	fire = 0.95
	acid = 1.0

/datum/rig_theme/station/science
	abstract_type = /datum/rig_theme/station/science
	armor = /datum/armor/rigsuit/station/science
	base_icon = 'icons/modules/rigsuits/suits/science.dmi'

AUTO_RIG_THEME(/station/science/standard)
/datum/rig_theme/station/science/standard
	name = "prototype rig"
	base_state = "prototype"
	desc = "A "
	fluff_desc = "TBD"
	display_name = "prototype"
	visible_name = "Prototype"
	#warn impl

/datum/armor/rigsuit/station/science/anomaly
	melee = 0.1
	melee_tier = MELEE_TIER_HEAVY
	bullet = 0.1
	bullet_tier = BULLET_TIER_HIGH
	laser_soak = 5
	energy = 0.55

AUTO_RIG_THEME(/station/science/anomaly)
/datum/rig_theme/station/science/anomaly
	name = "anomaly rig"
	base_state = "apocryphal"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "AMI"
	visible_name = "AMI"
	armor = /datum/armor/rigsuit/station/science/anomaly
	#warn impl
