//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_state/blockfill
	var/double_click_to_confirm = TRUE

	var/fill_type
	var/fill_type_area
	var/fill_type_border
	var/fill_atmos

	var/datum/buildmode_region/selected_region

/datum/buildmode_middleware/blockfill
	state_type = /datum/buildmode_state/blockfill

/datum/buildmode_middleware/blockfill/handle_click(client/user, datum/admins/holder, datum/buildmode_state/state, atom/click_target, list/click_params)
	. = ..()

/datum/buildmode_middleware/blockfill/handle_topic(client/user, datum/admins/holder, datum/buildmode_state/state, action, list/params)
	. = ..()


/datum/buildmode_middleware/blockfill/proc/validate_atmos_string(str)

/datum/buildmode_middleware/blockfill/proc/fill(datum/buildmode_state/blockfill)
