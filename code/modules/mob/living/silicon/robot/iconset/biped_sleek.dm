//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_iconset/biped_sleek
	display_name = "Ward-Takashi Operator"
	abstract_type = /datum/prototype/robot_iconset/biped_sleek
	auto_chassis = /datum/prototype/robot_chassis/biped
	icon = 'icons/mob/robot/iconset/biped_sleek.dmi'
	icon_state_cover = "panel"
	icon_state_indicator = "indicator"

/datum/prototype/robot_iconset/biped_sleek/standard
	icon_state = "standard"

/datum/prototype/robot_iconset/biped_sleek/janitor
	icon_state = "janitor"

/datum/prototype/robot_iconset/biped_sleek/medical
	display_name = /datum/prototype/robot_iconset/biped_sleek::display_name + " (Medical)"
	icon_state = "medical"

/datum/prototype/robot_iconset/biped_sleek/security
	icon_state = "security"
	icon_state_indicator = "indicator-security"

/datum/prototype/robot_iconset/biped_sleek/mining
	icon_state = "mining"

/datum/prototype/robot_iconset/biped_sleek/service
	icon_state = "service"

/datum/prototype/robot_iconset/biped_sleek/science
	icon_state = "science"

/datum/prototype/robot_iconset/biped_sleek/clerical
	icon_state = "clerical"

/datum/prototype/robot_iconset/biped_sleek/engineering
	icon_state = "engineering"
	icon_state_indicator = "indicator-commmand"

/datum/prototype/robot_iconset/biped_sleek/cmo
	display_name = /datum/prototype/robot_iconset/biped_sleek::display_name + " (CMO)"
	icon_state = "cmo"
	icon_state_indicator = "indicator-commmand"

/datum/prototype/robot_iconset/biped_sleek/hos
	icon_state = "hos"
	icon_state_indicator = "indicator-security"

/datum/prototype/robot_iconset/biped_sleek/gravekeeper
	icon_state = "gravekeeper"
