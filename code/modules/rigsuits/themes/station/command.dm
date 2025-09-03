//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/rig_theme/station/command
	abstract_type = /datum/rig_theme/station/command
	base_icon = 'icons/modules/rigsuits/suits/command.dmi'

DECLARE_RIG_THEME(/station/command/captain)
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
	#warn encumbrance

/datum/armor/rigsuit/station/command/captain
	melee = 0.4
	melee_tier = 4
	melee_soak = 0
	melee_deflect = 5
	bullet = 0.35
	bullet_tier = 4
	bullet_soak = 0
	bullet_deflect = 5
	laser = 0.35
	laser_tier = 4
	laser_soak = 5
	laser_deflect = 0
	energy = 0.35
	bomb = 0.45
	bio = 1.0
	rad = 0.35
	fire = 0.75
	acid = 1.0
