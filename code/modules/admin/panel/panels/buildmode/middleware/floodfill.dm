//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_state/floodfill
	var/

/datum/buildmode_middleware/floodfill
	state_type = /datum/buildmode_state/floodfill

/datum/buildmode_middleware/floodfill/handle_click(client/user, datum/admins/holder, datum/buildmode_state/state, atom/click_target, list/click_params)
	. = ..()

/datum/buildmode_middleware/floodfill/handle_topic(client/user, datum/admins/holder, datum/buildmode_state/state, action, list/params)
	. = ..()

