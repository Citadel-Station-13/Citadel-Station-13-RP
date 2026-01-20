//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Minimum delay in deciseconds between fast-mouse updates like zooming and facing cursor.
 */
GLOBAL_VAR_INIT(client_mouse_fast_update_backoff, 1)

// TODO: this is fine for now but if the server becomes highpop we may need to re-evaluate this
/client/MouseMove(object, location, control, params)
	// object intentionally ignored to prevent hard-refing things that might gc
	// location intentionally ignored to prevent footgunning. the player moving doesn't update it.
	mouse_control_last = control
	mouse_params_last = params
	mouse_params_last_unpacked = null
	SEND_SIGNAL(src, COMSIG_CLIENT_MOUSE_MOVED)
	..()

/**
 * Unpacks mouse params if they are stored.
 * * Cached, if user hasn't moved mouse again it'll not re-query.
 */
/client/proc/get_mouse_params()
	if(mouse_params_last_unpacked)
		return mouse_params_last_unpacked
	if(!mouse_params_last)
		return null
	mouse_params_last_unpacked = params2list(mouse_params_last)
	return mouse_params_last_unpacked

// TODO: code this in so we can have proper mouse handling; replace precision drop & clickchain angle getter with this
/**
 * Predicts actual mouse turf and x/y on that turf from screen loc.
 * This is done per-client due to viewport differences,
 * and done for turfs because icon x/y is variable on atoms.
 */
/client/proc/predict_mouse_tile_from_screen_loc(raw_screen_loc_string)
	// this is not implemented yet because i do not have the energy to deal with
	// pixel x/y shift on the client, what to do if viewport isn't an odd number,
	// and more Bullshit that I don't want to deal with.
	CRASH("not implemented yet")
