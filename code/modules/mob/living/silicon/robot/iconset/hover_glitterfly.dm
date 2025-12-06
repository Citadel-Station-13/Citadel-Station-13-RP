//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_iconset/hover_glitterfly
	display_name = "L3P1-D0T"
	abstract_type = /datum/prototype/robot_iconset/hover_glitterfly
	auto_chassis = /datum/prototype/robot_chassis/hover
	icon = 'icons/mob/robot/iconset/hover_glitterfly.dmi'
	icon_state_cover = "panel"

/datum/prototype/robot_iconset/hover_glitterfly/standard
	icon_state = "standard"
	icon_state_indicator = "standard-indicator"

/datum/prototype/robot_iconset/hover_glitterfly/janitor
	icon_state = "janitor"
	icon_state_indicator = "janitor-indicator"

/datum/prototype/robot_iconset/hover_glitterfly/service
	icon_state = "service"
	icon_state_indicator = "service-indicator"

/datum/prototype/robot_iconset/hover_glitterfly/surgeon
	icon_state = "surgeon"
	icon_state_indicator = "surgeon-indicator"

/datum/prototype/robot_iconset/hover_glitterfly/crisis
	icon_state = "crisis"
	icon_state_indicator = "crisis-indicator"

/datum/prototype/robot_iconset/hover_glitterfly/engineering
	icon_state = "engineering"
	icon_state_indicator = "engineering-indicator"

/datum/prototype/robot_iconset/hover_glitterfly/security
	icon_state = "security"
	icon_state_indicator = "security-indicator"

/datum/prototype/robot_iconset/hover_glitterfly/clerical
	display_name = /datum/prototype/robot_iconset/hover_glitterfly::display_name + " (Clerical)"
	icon_state = "clerical"
	icon_state_indicator = "clerical-indicator"

/datum/prototype/robot_iconset/hover_glitterfly/science
	icon_state = "science"
	icon_state_indicator = "science-indicator"

/datum/prototype/robot_iconset/hover_glitterfly/mining
	icon_state = "mining"
	icon_state_indicator = "mining-indicator"
