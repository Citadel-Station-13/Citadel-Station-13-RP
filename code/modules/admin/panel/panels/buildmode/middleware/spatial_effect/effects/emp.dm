//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_spatial_effect/emp
	id = "emp"
	ui_key = "emp"
	#warn ui icon

/datum/buildmode_spatial_effect/emp/execute_pinpoint(turf/location, datum/buildmode_spatial_config/emp/config)

/datum/buildmode_spatial_effect/emp/handle_topic(client/user, datum/admins/holder, datum/buildmode_state/spatial_effect/state, datum/buildmode_spatial_config/config, action, list/params)
	. = ..()
	if(.)
		return

/datum/buildmode_spatial_config/emp
	var/size_1 = 0
	var/size_2 = 0
	var/size_3 = 0
	var/size_4 = 0
