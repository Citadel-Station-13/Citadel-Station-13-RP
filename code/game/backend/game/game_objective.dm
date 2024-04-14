//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * completion status struct for objectives
 */
/datum/game_objective_status
	/// status enum
	var/status = GAME_OBJECTIVE_UNKNOWN
	/// ratio of completion, 0 to infinity inclusive; >= 1 means completed.
	var/ratio = 1
	/// qualitative description of completion: string or null
	var/explain = null

/datum/game_objective_status/proc/tgui_objective_status()
	return list(
		"status" = status,
		"ratio" = ratio,
		"explain" = explain,
	)

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
	#warn refactor that

/datum/game_objective/New(...)
	auto_build(args.Copy())

#warn how to handle 'auto build'..?
#warn a way to get live updating stuff

/datum/game_objective/proc/auto_build(list/specifiers)
	#warn impl

/**
 * completion check
 *
 * @params
 * * individual - if provided, we operate as individual mode
 * * faction - if provided, we operate as faction mode
 *
 * return /datum/game_objective_status
 */
/datum/game_objective/proc/check_status(datum/mind/individual, datum/game_faction/faction)
	SHOULD_NOT_OVERRIDE(TRUE)
	RETURN_TYPE(/datum/game_objective_status)
	if(!isnull(individual))
		. = check_status_individual(individual)
	else if(!isnull(faction))
		. = check_status_faction(faction)
	if(isnull(.))
		. = check_status_generic()


/datum/game_objective/proc/check_status_generic()
	return new /datum/game_objective_status

/**
 * return null to fallback to generic
 */
/datum/game_objective/proc/check_status_faction(datum/game_faction/faction)
	RETURN_TYPE(/datum/game_objective_status)
	return null

/**
 * return null to fallback to generic
 */
/datum/game_objective/proc/check_status_individual(datum/mind/mind)
	RETURN_TYPE(/datum/game_objective_status)
	return null

/**
 * tgui roundend data
 */
/datum/game_objective/proc/tgui_roundend_data(datum/game_faction/faction, datum/mind/mind)
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
		"status" = check_status(faction = faction, mind = mind),
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
	return task || "Custom Objective (adminhelp, shit broke)"

/**
 * builds explanation
 */
/datum/game_objective/proc/build_explanation()
	return explanation || "This is some sort of custom objective - please refer to the short description or adminhelp."
