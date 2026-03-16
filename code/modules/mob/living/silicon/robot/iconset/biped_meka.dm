//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//                    Attributions                         //
// All sprites used in this file made by GhostSheep/TheOOZ //

/datum/prototype/robot_iconset/biped_meka
	display_name = "Meka"
	abstract_type = /datum/prototype/robot_iconset/biped_meka
	auto_chassis = /datum/prototype/robot_chassis/biped

	variations = list(
		/datum/robot_iconset_variation/sitting,
		/datum/robot_iconset_variation/dead,
		/datum/robot_iconset_variation/resting,
	)

/datum/prototype/robot_iconset/biped_meka/one
	icon_state = "one"
	icon_state_indicator = "one-indicator"
	icon_state_cover = "one-cell"

/datum/prototype/robot_iconset/biped_meka/two
	icon_state = "two"
	icon_state_indicator = "two-indicator"
	icon_state_cover = "two-cell"

/datum/prototype/robot_iconset/biped_meka/three
	icon_state = "three"
	icon_state_indicator = "three-indicator"
	icon_state_cover = "three-cell"

/datum/prototype/robot_iconset/biped_meka/four
	icon_state = "four"
	icon_state_indicator = "four-indicator"
	icon_state_cover = "four-cell"
