//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_spatial_effect
	/// must be unique
	var/id
	/// expected config type
	var/config_type = /datum/buildmode_spatial_config
	/// ui interface resolution key
	var/ui_key
	/// ui interface icon
	var/ui_icon
	#warn default icon

/datum/buildmode_spatial_effect/proc/execute_pinpoint(turf/location, datum/buildmode_spatial_config/config)

/**
 * * `state` can be safely casted to our `state_type`.
 */
/datum/buildmode_spatial_effect/proc/handle_topic(client/user, datum/admins/holder, datum/buildmode_state/spatial_effect/state, datum/buildmode_spatial_config/config, action, list/params)
	SHOULD_CALL_PARENT(TRUE)

/**
 * * `state` can be safely casted to our `state_type`.
 */
/datum/buildmode_spatial_effect/proc/handle_click(client/user, datum/admins/holder, datum/buildmode_state/spatial_effect/state, datum/buildmode_spatial_config/config, atom/click_target, list/click_params)
	SHOULD_NOT_OVERRIDE(TRUE)

