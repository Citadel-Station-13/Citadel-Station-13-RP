//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/rig_theme/station/security
	abstract_type = /datum/rig_theme/station/security
	base_icon = 'icons/modules/rigsuits/suits/security.dmi'
	// combat rigs
	siemens_coefficient = 0.65

/datum/armor/rigsuit/station/security
	melee = 0.5
	melee_tier = MELEE_TIER_MEDIUM
	melee_soak = 2
	melee_deflect = 5
	bullet = 0.35
	bullet_tier = BULLET_TIER_MEDIUM
	bullet_soak = 5
	bullet_deflect = 0
	laser = 0.4
	laser_tier = LASER_TIER_MEDIUM
	laser_soak = 5
	laser_deflect = 0
	energy = 0.35
	bomb = 0.45
	bio = 1.0
	rad = 0.7
	fire = 0.75
	acid = 1.0

AUTO_RIG_THEME(/station/security/standard)
/datum/rig_theme/station/security/standard
	name = "security rig"
	base_state = "security"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "security"
	visible_name = "Security"
	#warn impl
	armor = /datum/armor/rigsuit/station/security
	base_weight = 15 // a little heavy
	offline_encumbrance = 40
	online_encumbrance = 25

/datum/armor/rigsuit/station/security/safeguard
	melee = 0.2
	melee_tier = MELEE_TIER_HEAVY
	bullet = 0.2
	bullet_tier = BULLET_TIER_HIGH
	laser = 0.2
	laser_tier = LASER_TIER_HIGH

AUTO_RIG_THEME(/station/security/safeguard)
/datum/rig_theme/station/security/safeguard
	name = "safeguard rig"
	base_state = "safeguard"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "safeguard"
	visible_name = "Safeguard"
	#warn impl
	armor = /datum/armor/rigsuit/station/security/safeguard
	base_weight = 15 // a little heavy
	offline_encumbrance = 50
	online_encumbrance = 25
