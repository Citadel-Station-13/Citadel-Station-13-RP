//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_iconset/hover_handy
	display_name = "Handy"
	abstract_type = /datum/prototype/robot_iconset/hover_handy
	auto_chassis = /datum/prototype/robot_chassis/hover
	icon = 'icons/mob/robot/iconset/hover_handy.dmi'
	icon_state_cover = "panel"

/datum/prototype/robot_iconset/hover_handy/standard
	icon_state = "standard"
	icon_state_indicator = "standard-indicator"

/datum/prototype/robot_iconset/hover_handy/hydroponics
	icon_state = "hydroponics"
	icon_state_indicator = "hydroponics-indicator"

/datum/prototype/robot_iconset/hover_handy/clerk
	display_name = /datum/prototype/robot_iconset/hover_handy::display_name + " (Clerk)"
	icon_state = "clerk"
	icon_state_indicator = "clerk-indicator"

/datum/prototype/robot_iconset/hover_handy/janitor
	icon_state = "janitor"
	icon_state_indicator = "janitor-indicator"

/datum/prototype/robot_iconset/hover_handy/service
	display_name = /datum/prototype/robot_iconset/hover_handy::display_name + " (Service)"
	icon_state = "service"
	icon_state_indicator = "service-indicator"

/datum/prototype/robot_iconset/hover_handy/mining
	icon_state = "mining"
	icon_state_indicator = "mining-indicator"

/datum/prototype/robot_iconset/hover_handy/security
	icon_state = "security"
	icon_state_indicator = "security-indicator"

/datum/prototype/robot_iconset/hover_handy/medical
	icon_state = "medical"
	icon_state_indicator = "medical-indicator"

/datum/prototype/robot_iconset/hover_handy/engineering
	icon_state = "engineering"
	icon_state_indicator = "engineering-indicator"

/datum/prototype/robot_iconset/hover_handy/science
	icon_state = "science"
	icon_state_indicator = "science-indicator"
