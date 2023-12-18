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

/datum/game_objective/New()

#warn how to handle 'auto build'..?

/**
 * completion check
 *
 * @params
 * * individual - if provided, we operate as individual mode
 * * faction - if provided, we operate as faction mode
 * * status - provide vague completion status
 * * exact - provide exact numbers
 *
 * return list("status" = GAME_OBJECTIVE_X status enum, "ratio" = -1 to 1 for how failed/succeeded, "explain" = qualitative blurb)
 */
/datum/game_objective/proc/check_completion(datum/mind/individual, datum/game_faction/faction, status = TRUE, exact = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(!isnull(individual))
		. = check_completion_individual(individual)
	else if(!isnull(faction))
		. = check_completion_faction(faction)
	if(isnull(.))
		. = check_completion_generic()


/datum/game_objective/proc/check_completion_generic()
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
 * return null to fallback to generic
 */
/datum/game_objective/proc/check_completion_faction(datum/game_faction/faction)
	return null

/**
 * return null to fallback to generic
 */
/datum/game_objective/proc/check_completion_individual(datum/mind/mind)
	return null

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

/**
 * update explanation
 */
/datum/game_objective/proc/update()
	task = build_task()
	explanation = build_explanation()

/**
 * builds task
 */
/datum/game_objective/proc/build_task()
	return task | "Custom Objective (adminhelp, shit broke)"

/**
 * builds explanation
 */
/datum/game_objective/proc/build_explanation()
	return explanation || "This is some sort of custom objective - please refer to the short description or adminhelp."
