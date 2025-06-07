//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_state/air
	var/double_click_to_confirm = TRUE
	var/fill_atmos

/datum/buildmode_middleware/air
	id = "air"
	ui_key = "air"
	#warn ui_icon
	state_type = /datum/buildmode_state/air

/datum/buildmode_middleware/air/handle_click(client/user, datum/admins/holder, datum/buildmode_state/state, atom/click_target, list/click_params)
	. = ..()

/datum/buildmode_middleware/air/handle_topic(client/user, datum/admins/holder, datum/buildmode_state/state, action, list/params)
	. = ..()


/datum/buildmode_middleware/air/proc/validate_atmos_string(str)

/datum/buildmode_middleware/air/proc/execute(turf/target)
