//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Checks if we should examine on shift click
 * * This is from ourselves, not from remote control.
 * * This doesn't prevent examines, this just is a control / input thing.
 *   Context menus usually still allow examining.
 */
/mob/proc/should_client_shift_click_examine(atom/entity)
	return TRUE
