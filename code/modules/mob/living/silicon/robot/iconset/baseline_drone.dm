//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_iconset/baseline_drone
	display_name = "Maintenance Drone"
	abstract_type = /datum/prototype/robot_iconset/baseline_drone
	auto_chassis = /datum/prototype/robot_chassis/baseline
	icon = 'icons/mob/robot/iconset/baseline_drone.dmi'
	icon_state_cover = "panel"
	icon_state_indicator = "indicator-lights"

/datum/prototype/robot_iconset/baseline_drone/construction
	icon_state = "construction"
	icon_state_indicator = "construction-indicator"

/datum/prototype/robot_iconset/baseline_drone/mining
	icon_state = "mining"
	icon_state_indicator = "mining-indicator"
