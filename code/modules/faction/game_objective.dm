//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * an objective
 *
 * these are more 'handler'-likes, usually created by storyteller, rather than being hard defined objectives like on /tg/
 */
/datum/game_objective
	/// generated friendly name
	var/name
	/// short description of task - no HTML, please
	var/task
	/// long description to show - HTML allowed
	var/explanation

/**
 * binary completion check
 */
/datum/game_objective/proc/check_completion()
	return TRUE
