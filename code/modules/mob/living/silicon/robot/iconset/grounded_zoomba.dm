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
	indicator_lighting_coloration_packed = "#00ff6e"

/datum/prototype/robot_iconset/grounded_zoomba/engineering
	icon_state = "engineering"
	indicator_lighting_coloration_packed = "#ffae00"

/datum/prototype/robot_iconset/grounded_zoomba/janitor
	icon_state = "janitor"
	indicator_lighting_coloration_packed = "#cc00ff"

/datum/prototype/robot_iconset/grounded_zoomba/medical
	icon_state = "medical"
	indicator_lighting_coloration_packed = "#00ffff"

/datum/prototype/robot_iconset/grounded_zoomba/crisis
	icon_state = "crisis"
	indicator_lighting_coloration_packed = "#00ffff"

/datum/prototype/robot_iconset/grounded_zoomba/miner
	icon_state = "miner"
	indicator_lighting_coloration_packed = "#9f561f"

/datum/prototype/robot_iconset/grounded_zoomba/research
	icon_state = "research"
	indicator_lighting_coloration_packed = "#8800ff"

/datum/prototype/robot_iconset/grounded_zoomba/service
	icon_state = "service"
	indicator_lighting_coloration_packed = "#16b102"

/datum/prototype/robot_iconset/grounded_zoomba/combat
	icon_state = "combat"
	indicator_lighting_coloration_packed = "#ff0000"

/datum/prototype/robot_iconset/grounded_zoomba/security
	icon_state = "security"
	variations = list()
	indicator_lighting_coloration_packed = "#ff0000"
