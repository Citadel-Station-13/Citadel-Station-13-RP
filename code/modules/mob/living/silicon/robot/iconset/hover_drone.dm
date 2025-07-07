//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_iconset/hover_drone
	display_name = "Drone"
	abstract_type = /datum/prototype/robot_iconset/hover_drone
	auto_chassis = /datum/prototype/robot_chassis/hover
	icon = 'icons/mob/robot/iconset/hover_drone.dmi'
	icon_state_cover = "panel"

/datum/prototype/robot_iconset/hover_drone/standard
	icon_state = "standard"
	icon_state_indicator = "standard-indicator"

/datum/prototype/robot_iconset/hover_drone/engineering
	icon_state = "engineering"
	icon_state_indicator = "engineering-indicator"

/datum/prototype/robot_iconset/hover_drone/mining
	icon_state = "mining"
	icon_state_indicator = "mining-indicator"

/datum/prototype/robot_iconset/hover_drone/janitor
	icon_state = "janitor"
	icon_state_indicator = "janitor-indicator"

/datum/prototype/robot_iconset/hover_drone/medical
	display_name = /datum/prototype/robot_iconset/hover_drone::display_name + " (Medical)"
	icon_state = "medical"
	icon_state_indicator = "medical-indicator"

/datum/prototype/robot_iconset/hover_drone/surgery
	display_name = /datum/prototype/robot_iconset/hover_drone::display_name + " (Surgery)"
	icon_state = "surgery"
	icon_state_indicator = "surgery-indicator"

/datum/prototype/robot_iconset/hover_drone/security
	icon_state = "security"
	icon_state_indicator = "security-indicator"

/datum/prototype/robot_iconset/hover_drone/service
	display_name = /datum/prototype/robot_iconset/hover_drone::display_name + " (Service)"
	icon_state = "service"
	icon_state_indicator = "service-indicator"

/datum/prototype/robot_iconset/hover_drone/lost
	icon_state = "lost"
	icon_state_indicator = "lost-indicator"

/datum/prototype/robot_iconset/hover_drone/chemistry
	icon_state = "chemistry"
	icon_state_indicator = "chemistry-indicator"

/datum/prototype/robot_iconset/hover_drone/hydroponics
	display_name = /datum/prototype/robot_iconset/hover_drone::display_name + " (Hydroponics)"
	icon_state = "hydroponics"
	icon_state_indicator = "hydroponics-indicator"

/datum/prototype/robot_iconset/hover_drone/science
	icon_state = "science"
	icon_state_indicator = "science-indicator"

/datum/prototype/robot_iconset/hover_drone/blueshield
	icon_state = "blueshield"
	icon_state_indicator = "blueshield-indicator"

/datum/prototype/robot_iconset/hover_drone/gravekeeper
	icon_state = "gravekeeper"
	icon_state_indicator = "gravekeeper-indicator"
