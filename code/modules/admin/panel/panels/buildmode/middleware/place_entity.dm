//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_state/place_entity
	var/selected_type
	var/selected_dir = SOUTH

/datum/buildmode_middleware/place_entity
	state_type = /datum/buildmode_state/place_entity
	id = "place_entity"
	ui_key = "place_entity"
	#warn ui icon

/datum/buildmode_middleware/place_entity/handle_click(client/user, datum/admins/holder, datum/buildmode_state/state, atom/click_target, list/click_params)
	. = ..()

/datum/buildmode_middleware/place_entity/handle_topic(client/user, datum/admins/holder, datum/buildmode_state/state, action, list/params)
	. = ..()

/datum/buildmode_middleware/place_entity/proc/instance_entity(entity_type, turf/location, list/click_params)
	if(ispath(entity_type, /turf))
	else if(ispath(entity_type, /area))
		return
	else
		var/atom/movable/casted_movable = entity_type
