//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

GLOBAL_LIST_INIT(admin_buildmode_middleware, init_admin_buildmode_middleware())
GLOBAL_PROTECT(admin_buildmode_middleware)

/proc/init_admin_buildmode_middleware()
	#warn impl

/datum/buildmode_middleware
	var/state_type = /datum/buildmode_state

/**
 * * `state` can be safely casted to our `state_type`.
 */
/datum/buildmode_middleware/proc/handle_topic(client/user, datum/admins/holder, datum/buildmmode_state/state, action, list/params)

/**
 * * `state` can be safely casted to our `state_type`.
 */
/datum/buildmode_middleware/proc/handle_click(client/user, datum/admins/holder, datum/buildmmode_state/state, atom/click_target, list/click_params)

