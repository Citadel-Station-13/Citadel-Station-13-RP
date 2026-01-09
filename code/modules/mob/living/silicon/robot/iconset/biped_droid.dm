//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_iconset/biped_droid
	display_name = "Droid"
	abstract_type = /datum/prototype/robot_iconset/biped_droid
	auto_chassis = /datum/prototype/robot_chassis/biped
	icon = 'icons/mob/robot/iconset/biped_droid.dmi'
	icon_state_cover = "panel"
	indicator_lighting_coloration_mode = COLORATION_MODE_MULTIPLY

/datum/prototype/robot_iconset/biped_droid/logistics
	icon_state = "logistics"
	icon_state_indicator = "indicator-lighting-logistics"

/datum/prototype/robot_iconset/biped_droid/medical
	icon_state = "medical"
	icon_state_indicator = "indicator-lighting-medical"

/datum/prototype/robot_iconset/biped_droid/science
	icon_state = "science"
	icon_state_indicator = "indicator-lighting-medical"
