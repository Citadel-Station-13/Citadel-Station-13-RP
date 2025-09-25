//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/rig_theme/station/command
	abstract_type = /datum/rig_theme/station/command
	base_icon = 'icons/modules/rigsuits/suits/command.dmi'

AUTO_RIG_THEME(/station/command/captain)
/datum/rig_theme/station/command/captain
	name = "director rig"
	base_state = "magnate"
	desc = "A reinforced hardsuit used by the captain of the installation."
	fluff_desc = "A modification of the successful <b>S-3</b> lineage from Hephaestus Industries, this is a \
	special issue hardsuit offered to the leaders of Nanotrasen's deep-space installations. It is unnaturally \
	protective for such a (relatively) mobile suit, being fitted with high quality alloys and compliant \
	interlocks."
	display_name = "director"
	visible_name = "Director"
	armor = /datum/armor/rigsuit/station/command/captain
	base_weight = 30 // heavy as hell
	offline_encumbrance = 60 // heavy as hell
	online_encumbrance = 40 // heavy as hell

/datum/armor/rigsuit/station/command/captain
	melee = 0.4
	melee_tier = MELEE_TIER_HEAVY
	melee_soak = 0
	melee_deflect = 5
	bullet = 0.35
	bullet_tier = BULLET_TIER_HIGH
	bullet_soak = 0
	bullet_deflect = 5
	laser = 0.35
	laser_tier = LASER_TIER_HIGH
	laser_soak = 5
	laser_deflect = 0
	energy = 0.35
	bomb = 0.45
	bio = 1.0
	rad = 0.65
	fire = 0.75
	acid = 1.0
