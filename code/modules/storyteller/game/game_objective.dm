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
	/// when FALSE, completion is not reported, nor do some objectives like 'survive' give exact measures.
	var/greentext_syndrome = FALSE
	/// when TRUE, not even the explanation blurb is reported for completion
	var/baystation_syndrome = FALSE

/**
 * completion check
 *
 * return list(binary yes/no or null, percentage from 0 to 1 or null, description)
 */
/datum/game_objective/proc/check_completion(datum/game_faction/faction)
	return list(
		"status" = null,
		"ratio" = null,
		"explain" = null,
	)
