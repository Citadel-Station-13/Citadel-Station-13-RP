//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * have a certain amount of your team alive at round end
 */
/datum/game_objective/survive
	name = "Survive"
	/// target percent from 0 to 100
	var/required_percent = 100

/datum/game_objective/survive/New(percent_required)
	if(!isnull(percent_required))
		src.required_percent = percent_required
	..()

#warn impl

/datum/game_objective/survive/check_completion()
	return list(
		"status",
		"ratio",
		"explain",
	)
	#warn impl

/datum/game_objective/survive/build_task()
	return "Survive."
	#warn impl

/datum/game_objective/survive/build_explanation()
	#warn internally specific?
	return "Ensure at least [required_percent]% of your team survives until the end of the round."
