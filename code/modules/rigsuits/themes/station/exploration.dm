//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/armor/rigsuit/station/exploration
	melee = 0.45
	melee_tier = MELEE_TIER_MEDIUM
	melee_soak = 0
	melee_deflect = 5
	bullet = 0.35
	bullet_tier = BULLET_TIER_MEDIUM
	bullet_soak = 0
	bullet_deflect = 0
	laser = 0.35
	laser_tier = LASER_TIER_MEDIUM
	laser_soak = 5
	laser_deflect = 0
	energy = 0.35
	bomb = 0.35
	bio = 1.0
	rad = 0.85
	fire = 0.75
	acid = 1.0

/datum/rig_theme/station/exploration
	abstract_type = /datum/rig_theme/station/exploration
	base_icon = 'icons/modules/rigsuits/suits/exploration.dmi'
	pieces = list(
		/datum/rig_theme_piece/helmet,
		/datum/rig_theme_piece/chestplate,
		/datum/rig_theme_piece/gloves,
		/datum/rig_theme_piece/boots{
			piece_base_state = "";
		},
	)
	control_base_state_worn = ""
	control_sealed_append = ""
	max_pressure_protect = ONE_ATMOSPHERE * 12.5
	max_temperature_protect = HEAT_PROTECTION_INDUSTRIAL_VOIDSUIT
	armor = /datum/armor/rigsuit/station/exploration
	base_weight = 15 // heavy
	offline_encumbrance = 30
	online_encumbrance = 20

AUTO_RIG_THEME(/station/exploration/standard)
/datum/rig_theme/station/exploration/standard
	name = "excursion rig"
	base_state = "explo"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "excursion"
	visible_name = "excursion"
	#warn impl

// the protagonist armor :skull:
/datum/armor/rigsuit/station/exploration/pathfinder
	melee = 0.55
	bullet = 0.45
	laser = 0.45

AUTO_RIG_THEME(/station/exploration/pathfinder)
/datum/rig_theme/station/exploration/pathfinder
	name = "pathfinder rig"
	base_state = "pf"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "pathfinder"
	visible_name = "pathfinder"
	control_base_state_worn = null
	armor = /datum/armor/rigsuit/station/exploration/pathfinder
	#warn impl

AUTO_RIG_THEME(/station/exploration/medic)
/datum/rig_theme/station/exploration/medic
	name = "field medic rig"
	base_state = "medic"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "medic"
	visible_name = "medic"
	#warn impl

AUTO_RIG_THEME(/station/exploration/pilot)
/datum/rig_theme/station/exploration/pilot
	name = "pilot rig"
	base_state = "pilot"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "pilot"
	visible_name = "pilot"
	#warn impl
