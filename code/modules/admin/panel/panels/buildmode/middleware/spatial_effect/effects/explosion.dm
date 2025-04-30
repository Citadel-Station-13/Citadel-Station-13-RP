//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_spatial_effect/explosion
	id = "explosion"
	ui_key = "explosion"
	#warn ui icon

/datum/buildmode_spatial_effect/explosion/execute_pinpoint(turf/location, datum/buildmode_spatial_config/explosion/config)

/datum/buildmode_spatial_effect/explosion/handle_topic(client/user, datum/admins/holder, datum/buildmode_state/spatial_effect/state, datum/buildmode_spatial_config/config, action, list/params)
	. = ..()
	if(.)
		return

/datum/buildmode_spatial_config/explosion
	var/size_1 = 0
	var/size_2 = 0
	var/size_3 = 0
	var/flash = 0
	var/z_transfer_up = TRUE
	var/z_transfer_down = TRUE
