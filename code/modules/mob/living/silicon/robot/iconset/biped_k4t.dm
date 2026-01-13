//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//                    Attributions                        //
// All sprites used in this file made by Zydras           //

/datum/prototype/robot_iconset/biped_k4t
	display_name = "K4T"
	icon_state = "k4t"
	icon_state_cover = "panel"
	icon_state_indicator = "indicator"

	auto_chassis = /datum/prototype/robot_chassis/biped

	variations = list(
		/datum/robot_iconset_variation/bellyup,
		/datum/robot_iconset_variation/dead,
		/datum/robot_iconset_variation/resting,
	)
