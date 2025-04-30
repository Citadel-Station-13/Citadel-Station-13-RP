//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_state/basic
	var/selected_type
	var/selected_dir = SOUTH

/datum/buildmode_middleware/basic
	state_type = /datum/buildmode_state/basic
	id = "basic"
	ui_key = "basic"
	#warn ui icon

/datum/buildmode_middleware/basic/handle_click(client/user, datum/admins/holder, datum/buildmode_state/state, atom/click_target, list/click_params)
	. = ..()

/datum/buildmode_middleware/basic/handle_topic(client/user, datum/admins/holder, datum/buildmode_state/state, action, list/params)
	. = ..()

/datum/buildmode_middleware/basic/proc/instance_entity(entity_type, turf/location, list/click_params)
	if(ispath(entity_type, /turf))
	else if(ispath(entity_type, /area))
		return
	else
		var/atom/movable/casted_movable = entity_type
