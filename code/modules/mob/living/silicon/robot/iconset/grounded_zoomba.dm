//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_iconset/zoomba
	abstract_type = /datum/prototype/robot_iconset/zoomba

	icon = 'icons/mob/robot/iconset/zoomba.dmi'
	icon_state_indicator = "indicator-lighting"
	icon_state_cover = "cover"

	indicator_lighting_coloration_mode = COLORATION_MODE_MULTIPLY

	variations = list(
		/datum/robot_iconset_variation/dead,
	)

/datum/prototype/robot_iconset/zoomba/standard
	icon_state = "standard"

/datum/prototype/robot_iconset/zoomba/clerical
	icon_state = "clerical"

/datum/prototype/robot_iconset/zoomba/engineering
	icon_state = "engineering"

/datum/prototype/robot_iconset/zoomba/janitor
	icon_state = "janitor"

/datum/prototype/robot_iconset/zoomba/medical
	icon_state = "medical"

/datum/prototype/robot_iconset/zoomba/crisis
	icon_state = "crisis"

/datum/prototype/robot_iconset/zoomba/miner
	icon_state = "miner"

/datum/prototype/robot_iconset/zoomba/research
	icon_state = "research"

/datum/prototype/robot_iconset/zoomba/service
	icon_state = "service"

/datum/prototype/robot_iconset/zoomba/combat
	icon_state = "combat"

/datum/prototype/robot_iconset/zoomba/security
	icon_state = "security"
	variations = list()
