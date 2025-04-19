//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_iconset/raptor
	display_name = "Raptor"
	abstract_type = /datum/prototype/robot_iconset/raptor
	auto_chassis = /datum/prototype/robot_chassis/quadruped/raptor
	icon = 'icons/mob/robot/iconset/raptor.dmi'
	icon_state_cover = "panel"
	variations = list(
		/datum/robot_iconset_variation/dead,
		/datum/robot_iconset_variation/bellyup,
		/datum/robot_iconset_variation/resting,
	)

/datum/prototype/robot_iconset/raptor/gravekeeper
	icon_state = "gravekeeper"
	icon_state_indicator = "indicator"

/datum/prototype/robot_iconset/raptor/gravekeeper
	icon_state = "lost"
	icon_state_indicator = "indicator"

/datum/prototype/robot_iconset/raptor/lost
	icon_state = "service"
	icon_state_indicator = "indicator"

/datum/prototype/robot_iconset/raptor/service
	icon_state = "security"
	icon_state_indicator = "indicator"

/datum/prototype/robot_iconset/raptor/security
	icon_state = "mining"
	icon_state_indicator = "indicator"

/datum/prototype/robot_iconset/raptor/mining
	icon_state = "medical"
	icon_state_indicator = "indicator"

/datum/prototype/robot_iconset/raptor/medical
	icon_state = "medical"
	icon_state_indicator = "indicator"

/datum/prototype/robot_iconset/raptor/janitor
	icon_state = "janitor"
	icon_state_indicator = "indicator"

/datum/prototype/robot_iconset/raptor/centcom
	icon_state = "centcom"
	icon_state_indicator = "indicator"

/datum/prototype/robot_iconset/raptor/engineering
	icon_state = "engineering"
	icon_state_indicator = "indicator"

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
