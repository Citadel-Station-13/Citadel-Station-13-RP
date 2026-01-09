//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//                    Attributions                        //
// All sprites used in this file made by mizartz.carrd.co //

/datum/prototype/robot_iconset/drake_mizartz
	display_name = "Mizartz"
	abstract_type = /datum/prototype/robot_iconset/drake_mizartz
	auto_chassis = /datum/prototype/robot_chassis/quadruped/draconic

	icon = 'icons/mob/robot/iconset/drake_mizartz.dmi'
	icon_state_indicator = "indicator-lighting"
	icon_state_cover = "open"

	icon_dimension_x = 64
	icon_dimension_y = 32

	indicator_lighting_coloration_mode = COLORATION_MODE_MULTIPLY

	variations = list(
		/datum/robot_iconset_variation/dead,
		/datum/robot_iconset_variation/resting,
		/datum/robot_iconset_variation/sitting,
		/datum/robot_iconset_variation/bellyup,
	)

/datum/prototype/robot_iconset/drake_mizartz/mining
	icon_state = "mining"

/datum/prototype/robot_iconset/drake_mizartz/medical
	icon_state = "medical"

/datum/prototype/robot_iconset/drake_mizartz/janitor
	icon_state = "janitor"
	indicator_lighting_coloration_mode = COLORATION_MODE_NONE

/datum/prototype/robot_iconset/drake_mizartz/security
	icon_state = "security"

/datum/prototype/robot_iconset/drake_mizartz/engineering
	icon_state = "engineering"

/datum/prototype/robot_iconset/drake_mizartz/peacekeeper
	icon_state = "peacekeeper"

/datum/prototype/robot_iconset/drake_mizartz/janitor
	icon_state = "janitor"
	icon_state_indicator = "indicator-lighting-janitor"
