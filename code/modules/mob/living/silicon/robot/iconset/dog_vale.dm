//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_iconset/dog_vale
	display_name = "Canine - Vale"
	abstract_type = /datum/prototype/robot_iconset/dog_vale
	auto_chassis = /datum/prototype/robot_chassis/quadruped/canine
	icon = 'icons/mob/robot/iconset/dog_vale.dmi'
	icon_state_cover = "panel"
	icon_dimension_x = 64

	variations = list(
		/datum/robot_iconset_variation/bellyup,
		/datum/robot_iconset_variation/sitting,
		/datum/robot_iconset_variation/dead,
		/datum/robot_iconset_variation/resting,
	)

/datum/prototype/robot_iconset/dog_vale/standard
	icon_state = "standard"
	icon_state_indicator = "standard-indicator"

/datum/prototype/robot_iconset/dog_vale/medical
	icon_state = "medical"
	icon_state_indicator = "medical-indicator"

/datum/prototype/robot_iconset/dog_vale/science
	icon_state = "science"
	icon_state_indicator = "science-indicator"

/datum/prototype/robot_iconset/dog_vale/security
	icon_state = "security"
	icon_state_indicator = "security-indicator"

/datum/prototype/robot_iconset/dog_vale/engineering
	icon_state = "engineering"
	icon_state_indicator = "engineering-indicator"

/datum/prototype/robot_iconset/dog_vale/mining
	icon_state = "mining"
	icon_state_indicator = "mining-indicator"

/datum/prototype/robot_iconset/dog_vale/janitor
	icon_state = "janitor"
	icon_state_indicator = "janitor-indicator"

/datum/prototype/robot_iconset/dog_vale/service
	icon_state = "service"
	icon_state_indicator = "service-indicator"

/datum/prototype/robot_iconset/dog_vale/service_dark
	display_name = /datum/prototype/robot_iconset/dog_vale::display_name + " (Dark)"
	icon_state = "service_dark"
	icon_state_indicator = "service_dark-indicator"

/datum/prototype/robot_iconset/dog_vale/stray
	icon_state = "stray"
	icon_state_indicator = "stray-indicator"

/datum/prototype/robot_iconset/dog_vale/syndicate
	icon_state = "syndicate"
	icon_state_indicator = "syndicate-indicator"

/datum/prototype/robot_iconset/dog_vale/clown
	icon_state = "clown"
	icon_state_indicator = "clown-indicator"
