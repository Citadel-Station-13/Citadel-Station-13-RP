//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_iconset/dog_pupdozer
	abstract_type = /datum/prototype/robot_iconset/dog_pupdozer
	icon = 'icons/mob/robot/iconset/dog_pupdozer.dmi'
	icon_state_cover = "panel"
	icon_state_indicator = "indicator"
	variations = list(
		/datum/robot_iconset_variation/dead,
		/datum/robot_iconset_variation/resting,
		/datum/robot_iconset_variation/sitting,
	)

/datum/prototype/robot_iconset/dog_pupdozer/engineering
	icon_state = "engineering"

/datum/prototype/robot_iconset/dog_pupdozer/security
	icon_state = "security"
