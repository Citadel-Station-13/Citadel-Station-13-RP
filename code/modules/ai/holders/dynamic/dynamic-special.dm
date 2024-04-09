//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/ai_holder/dynamic
	/// call iterate_special
	var/iterate_special = FALSE

/**
 * called as special during iterate(), before the main state machine executes
 *
 * @return TRUE to interrupt **all** regular actions.
 */
/datum/ai_holder/dynamic/proc/iterate_special(cycles, mode, state)
	return FALSE
