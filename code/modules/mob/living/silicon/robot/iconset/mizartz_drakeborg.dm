//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//                    Attributions                        //
// All sprites used in this file made by mizartz.carrd.co //

/datum/prototype/robot_iconset/mizartz_drakeborg
	abstract_type = /datum/prototype/robot_iconset/mizartz_drakeborg

	icon = 'icons/mob/robot/iconset/mizartz_drakeborg.dmi'
	indicator_icon_state = "indicator-lighting"
	cover_icon_state = "open"

	variations = list(
		/datum/robot_iconset_variation/dead,
		/datum/robot_iconset_variation/resting,
		/datum/robot_iconset_variation/sitting,
		/datum/robot_iconset_variation/bellyup,
	)

/datum/prototype/robot_iconset/mizartz_drakeborg/mining
	icon_state = "mining"
	dead_state = "mining-wreck"

/datum/prototype/robot_iconset/mizartz_drakeborg/medical
	icon_state = "medical"
	dead_state = "medical-wreck"

/datum/prototype/robot_iconset/mizartz_drakeborg/janitor
	icon_state = "janitor"
	dead_state = "janitor-wreck"

/datum/prototype/robot_iconset/mizartz_drakeborg/security
	icon_state = "security"
	dead_state = "security-wreck"

/datum/prototype/robot_iconset/mizartz_drakeborg/engineering
	icon_state = "engineering"
	dead_state = "engineering-wreck"

/datum/prototype/robot_iconset/mizartz_drakeborg/peacekeeper
	icon_state = "peacekeeper"
	dead_state = "peacekeeper-wreck"

/datum/prototype/robot_iconset/mizartz_drakeborg/janitor
	icon_state = "janitor"
	dead_state = "janitor-wreck"
	indicator_icon_state = "indicator-lighting-janitor"
