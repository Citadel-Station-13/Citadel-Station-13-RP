//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_iconset/raptor
	display_name = "Raptor"
	abstract_type = /datum/prototype/robot_iconset/raptor
	chassis = /datum/prototype/robot_chassis/quadruped/raptor
	icon = 'icons/mob/robot/iconset/raptor.dmi'
	icon_state_cover = "panel"
	variations = list(
		/datum/robot_iconset_variation/dead,
		/datum/robot_iconset_variation/bellyup,
		/datum/robot_iconset_variation/resting,
	)

#warn add into relevant modules

/datum/prototype/robot_iconset/raptor/peacekeeper
	icon_state = "peacekeeper"
	icon_state_indicator = "indicator"

/datum/prototype/robot_iconset/raptor/syndicate_medical
	icon_state = "syndicate_medical"
	icon_state_indicator = "indicator-syndicate"

/datum/prototype/robot_iconset/raptor/syndicate_protector
	icon_state = "syndicate_protector"
	icon_state_indicator = "indicator-syndicate"

/datum/prototype/robot_iconset/raptor/syndicate_machinist
	icon_state = "syndicate_machinist"
	icon_state_indicator = "indicator-syndicate"
