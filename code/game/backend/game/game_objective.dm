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
	/// owning faction - if any (so when we're made)
	var/datum/game_faction/faction

/**
 * completion check
 *
 * return list("status" = GAME_OBJECTIVE_X status enum, "ratio" = -1 to 1 for how failed/succeeded, "explain" = qualitative blurb)
 */
/datum/game_objective/proc/check_completion()
	/**
	 * GameObjectiveCompletion{} -->
	 * status: GameObjectiveStatus;
	 * ratio: number;
	 * explain: string;
	 */
	return list(
		"status" = null,
		"ratio" = null,
		"explain" = null,
	)

/**
 * tgui roundend data
 */
/datum/game_objective/proc/tgui_roundend_data()
	/**
	 * GameObjective{} ->
	 *
	 * task: string;
	 * explanation: string;
	 * completion: GameObjectiveCompletion;
	 * showExplain: BooleanLike;
	 * showVictory: BooleanLike;
	 */
	return list(
		"task" = task,
		"explanation" = explanation,
		"completion" = check_completion(faction),
		"showExplain" = !baystation_syndrome,
		"showVictory" = greentext_syndrome,
	)
