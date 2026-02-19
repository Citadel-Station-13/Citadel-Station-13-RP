//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_iconset/baseline_standard
	display_name = "M-USE"
	abstract_type = /datum/prototype/robot_iconset/baseline_standard
	auto_chassis = /datum/prototype/robot_chassis/baseline
	icon = 'icons/mob/robot/iconset/baseline_standard.dmi'
	icon_state_cover = "panel"
	icon_state_indicator = "indicator-lights"

/datum/prototype/robot_iconset/baseline_standard/security
	icon_state = "security"

/datum/prototype/robot_iconset/baseline_standard/medical
	icon_state = "medical"

/datum/prototype/robot_iconset/baseline_standard/engineering
	icon_state = "engineering"

/datum/prototype/robot_iconset/baseline_standard/janitor
	icon_state = "janitor"

/datum/prototype/robot_iconset/baseline_standard/service
	display_name = /datum/prototype/robot_iconset/baseline_standard::display_name + " (Service)"
	icon_state = "service"

/datum/prototype/robot_iconset/baseline_standard/logistics
	icon_state = "logistics"

/datum/prototype/robot_iconset/baseline_standard/clerical
	display_name = /datum/prototype/robot_iconset/baseline_standard::display_name + " (Clerical)"
	icon_state = "clerical"

/datum/prototype/robot_iconset/baseline_standard/standard
	icon_state = "standard"
