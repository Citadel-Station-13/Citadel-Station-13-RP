//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_middleware/block
	state_type = /datum/buildmode_state/block

/datum/buildmode_middleware/block/proc/validate_atmos_string(str)

/datum/buildmode_middleware/block/proc/fill(datum/buildmode_state/block)

/datum/buildmode_state/block
	var/double_click_to_confirm = FALSE
	var/fill_type
	var/fill_type_border
	var/fill_atmos

	var/turf/lower_left
	var/turf/upper_right



