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
	base_weight = 12.5 // heavy
	offline_encumbrance = 30
	online_encumbrance = 20

AUTO_RIG_THEME(/station/exploration/standard)
/datum/rig_theme/station/exploration/standard
	name = "excursion rig"
	base_state = "explo"
	desc = "A belt-mounted rigsuit designed for the exploration of hazardous environments."
	fluff_desc = {"
		This Nanotrasen-made rigsuit is a product of recent R&D for the company's Exploration teams,
		designed in 2565 and first deployed to frontier stations in 2567 as a replacement to the bulky
		EVA suits previously in use, the "Shackleton" series RIG module has been miniaturized to a more
		compact form-factor than previous rigsuit iterations, allowing it to be worn around the waist similar
		to a belt. Its full metal visorless construction relies on sensors mounted along the sides of the
		helmet for sight.
	"}
	display_name = "excursion"
	visible_name = "excursion"

// the protagonist armor :skull:
/datum/armor/rigsuit/station/exploration/pathfinder
	melee = 0.55
	bullet = 0.45
	laser = 0.45

AUTO_RIG_THEME(/station/exploration/pathfinder)
/datum/rig_theme/station/exploration/pathfinder
	name = "pathfinder rig"
	base_state = "pf"
	desc = "A sturdy rigsuit designed for the exploration of hazardous environments. Gold trim indicates it \
		is the pathfinder's model."
	fluff_desc = {"
		This Nanotrasen-made rigsuit is a product of recent R&D for the company's Exploration teams,
		designed in 2565 and first deployed to frontier stations in 2567 as the "Shackleton" series
		as a replacement to the bulky EVA suits previously in use.
		This version has increased armor plating and liner thickness, requiring a standard back mount
		due to the added bulk.
		Its full metal visorless construction relies on sensors mounted along
		the sides of the helmet for sight.
	"}
	display_name = "pathfinder"
	visible_name = "pathfinder"
	control_base_state_worn = null
	armor = /datum/armor/rigsuit/station/exploration/pathfinder
	base_weight = 15

/**
 * the semi-protagonist's armor
 */
/datum/armor/rigsuit/station/exploration/medic
	melee = 0.4
	bullet = 0.325
	laser = 0.325
	rad = 0.95

AUTO_RIG_THEME(/station/exploration/medic)
/datum/rig_theme/station/exploration/medic
	name = "field medic rig"
	base_state = "medic"
	desc = "A belt-mounted rigsuit with blue trim, designed for the exploration of hazardous environments."
	fluff_desc = {"
		This Nanotrasen-made rigsuit is a product of recent R&D for the company's Exploration teams,
		designed in 2565 and first deployed to frontier stations in 2567 as a replacement to the bulky
		EVA suits previously in use, the "Shackleton" series RIG module has been miniaturized to a more
		compact form-factor than previous rigsuit iterations, allowing it to be worn around the waist similar
		to a belt. Its full metal visorless construction relies on sensors mounted along the sides of the
		helmet for sight. This medical version trades some armor for medical-grade filters and seals,
		makign it more resistant to certain threats.
	"}
	display_name = "medic"
	visible_name = "medic"
	armor = /datum/armor/rigsuit/station/exploration/medic

/**
 * the *real* protagonist's armor
 *
 * just don't get hit!
 */
/datum/armor/rigsuit/station/exploration/pilot
	melee = 0.15
	melee_tier = MELEE_TIER_HEAVY
	bullet = 0.15
	bullet_tier = BULLET_TIER_HIGH
	laser = 0.15
	laser_tier = LASER_TIER_HIGH
	rad = 1.0

AUTO_RIG_THEME(/station/exploration/pilot)
/datum/rig_theme/station/exploration/pilot
	name = "pilot rig"
	base_state = "pilot"
	desc = "A belt-mounted rigsuit designed for the exploration of hazardous environments."
	fluff_desc = {"
		This Nanotrasen-made rigsuit is a product of recent R&D for the company's Exploration teams,
		designed in 2565 and first deployed to frontier stations in 2567 as a replacement to the bulky
		EVA suits previously in use, the "Shackleton" series RIG module has been miniaturized to a more
		compact form-factor than previous rigsuit iterations, allowing it to be worn around the waist similar
		to a belt. Its full metal visorless construction relies on sensors mounted along the sides of the
		helmet for sight.
	"}
	display_name = "pilot"
	visible_name = "pilot"
	armor = /datum/armor/rigsuit/station/exploration/pilot
