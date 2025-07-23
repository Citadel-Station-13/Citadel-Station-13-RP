//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_state/repair
	var/double_click_to_confirm = FALSE

	var/clear_existing_entities = TRUE
	var/aggressively_clear_existing_entities = FALSE

	var/datum/buildmode_region/selected_region

/datum/buildmode_middleware/repair
	state_type = /datum/buildmode_state/repair

/datum/buildmode_middleware/repair/proc/reload_block(turf/lower_left, turf/upper_right)

/datum/buildmode_middleware/repair/handle_click(client/user, datum/admins/holder, datum/buildmode_state/state, atom/click_target, list/click_params)
	. = ..()

/datum/buildmode_middleware/repair/handle_topic(client/user, datum/admins/holder, datum/buildmode_state/state, action, list/params)
	. = ..()

