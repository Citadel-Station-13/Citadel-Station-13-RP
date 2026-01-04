//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_iconset/grounded_zoomba
	display_name = "ZOOM-BA"
	abstract_type = /datum/prototype/robot_iconset/grounded_zoomba

	auto_chassis = /datum/prototype/robot_chassis/grounded

	icon = 'icons/mob/robot/iconset/grounded_zoomba.dmi'
	icon_state_indicator = "indicator-lighting"
	icon_state_cover = "cover"

	indicator_lighting_coloration_mode = COLORATION_MODE_MULTIPLY

	variations = list(
		/datum/robot_iconset_variation/dead,
	)

/datum/prototype/robot_iconset/grounded_zoomba/standard
	icon_state = "standard"

/datum/prototype/robot_iconset/grounded_zoomba/clerical
	icon_state = "clerical"

/datum/prototype/robot_iconset/grounded_zoomba/engineering
	icon_state = "engineering"

/datum/prototype/robot_iconset/grounded_zoomba/janitor
	icon_state = "janitor"

/datum/prototype/robot_iconset/grounded_zoomba/medical
	icon_state = "medical"

/datum/prototype/robot_iconset/grounded_zoomba/crisis
	icon_state = "crisis"

/datum/prototype/robot_iconset/grounded_zoomba/miner
	icon_state = "miner"

/datum/prototype/robot_iconset/grounded_zoomba/research
	icon_state = "research"

/datum/prototype/robot_iconset/grounded_zoomba/service
	icon_state = "service"

/datum/prototype/robot_iconset/grounded_zoomba/combat
	icon_state = "combat"

/datum/prototype/robot_iconset/grounded_zoomba/security
	icon_state = "security"
	variations = list()
