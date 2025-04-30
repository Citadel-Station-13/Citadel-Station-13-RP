//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_state/move_region
	var/datum/buildmode_region/selected_region

/datum/buildmode_middleware/move_region
	state_type = /datum/buildmode_state/move_region

/datum/buildmode_middleware/move_region/handle_click(client/user, datum/admins/holder, datum/buildmode_state/state, atom/click_target, list/click_params)
	. = ..()

/datum/buildmode_middleware/move_region/handle_topic(client/user, datum/admins/holder, datum/buildmode_state/state, action, list/params)
	. = ..()

/datum/buildmode_middleware/move_region/proc/move_region(turf/lower_left, turf/upper_right, turf/to_lower_left_anchor, clockwise_rotation_degrees = 0)
	switch(clockwise_rotation_degrees)
		if(0, 90, 180, 270)
		else
			CRASH("invalid rotation degrees [clockwise_rotation_degrees]")


