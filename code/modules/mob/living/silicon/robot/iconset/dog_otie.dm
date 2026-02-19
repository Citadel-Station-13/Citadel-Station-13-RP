//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_iconset/dog_otie
	display_name = "Otie"
	abstract_type = /datum/prototype/robot_iconset/dog_otie
	auto_chassis = /datum/prototype/robot_chassis/quadruped/canine
	icon = 'icons/mob/robot/iconset/dog_otie.dmi'
	icon_state_cover = "panel"
	icon_dimension_x = 64
	variations = list(
		/datum/robot_iconset_variation/dead,
		/datum/robot_iconset_variation/resting,
		/datum/robot_iconset_variation/sitting,
		/datum/robot_iconset_variation/bellyup,
	)

/datum/prototype/robot_iconset/dog_otie/janitor
	icon_state = "janitor"
	icon_state_indicator = "janitor-indicator"

/datum/prototype/robot_iconset/dog_otie/security
	icon_state = "security"
	icon_state_indicator = "security-indicator"

/datum/prototype/robot_iconset/dog_otie/engineering
	icon_state = "engineering"
	icon_state_indicator = "engineering-indicator"

/datum/prototype/robot_iconset/dog_otie/science
	icon_state = "science"
	icon_state_indicator = "science-indicator"
