//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_middleware/spatial_effect
	state_type = /datum/buildmode_state/spatial_effect

/datum/buildmode_middleware/spatial_effect/handle_click(client/user, datum/admins/holder, datum/buildmode_state/state, atom/click_target, list/click_params)
	. = ..()

/datum/buildmode_middleware/spatial_effect/handle_topic(client/user, datum/admins/holder, datum/buildmode_state/state, action, list/params)
	. = ..()

/datum/buildmode_middleware/spatial_effect/proc/switch_effect(datum/buildmode_spatial_effect/effect)

/datum/buildmode_state/spatial_effect
	var/effect_id
	var/list/effect_config_by_id
