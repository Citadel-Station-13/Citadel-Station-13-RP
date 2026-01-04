//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_iconset/dog_borgi
	display_name = "Canine - Borgi"
	abstract_type = /datum/prototype/robot_iconset/dog_borgi
	auto_chassis = /datum/prototype/robot_chassis/quadruped/canine
	icon = 'icons/mob/robot/iconset/dog_borgi.dmi'
	icon_state_cover = "panel"
	icon_state_indicator = "indicator"
	variations = list(
		/datum/robot_iconset_variation/bellyup,
		/datum/robot_iconset_variation/resting,
		/datum/robot_iconset_variation/sitting,
		/datum/robot_iconset_variation/dead,
	)

/datum/prototype/robot_iconset/dog_borgi/standard
	icon_state = "standard"

/datum/prototype/robot_iconset/dog_borgi/engineering
	icon_state = "engineering"

/datum/prototype/robot_iconset/dog_borgi/janitor
	icon_state = "janitor"

/datum/prototype/robot_iconset/dog_borgi/medical
	icon_state = "medical"

/datum/prototype/robot_iconset/dog_borgi/science
	icon_state = "science"

/datum/prototype/robot_iconset/dog_borgi/security
	icon_state = "security"
