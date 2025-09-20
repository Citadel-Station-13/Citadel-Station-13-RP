//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/**
 * status indicators are assigned aligned to bottom left
 */
/datum/status_indicator
	var/icon = 'icons/mob/status_indicators.dmi'
	var/icon_state

	var/align_bottom_left_x = 1
	var/align_bottom_left_y = 1
	var/size_x = 16
	var/size_y = 16


#warn impl

/datum/status_indicator/busy
