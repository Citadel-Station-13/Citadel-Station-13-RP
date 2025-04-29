//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_middleware/repair
	state_type = /datum/buildmode_state/repair

/datum/buildmode_middleware/repair/proc/reload_block(turf/lower_left, turf/upper_right)

/datum/buildmode_state/repair
	var/double_click_to_confirm = FALSE
	var/turf/lower_left
	var/turf/upper_right

	var/clear_existing_entities = TRUE
	var/aggressively_clear_existing_entities = FALSE
