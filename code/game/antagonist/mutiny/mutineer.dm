var/datum/antagonist/mutineer/mutineers

/datum/antagonist/mutineer
	role_type = BE_MUTINEER
	role_text = "Mutineer"
	role_text_plural = "Mutineers"
	id = MODE_MUTINEER
	antag_indicator = "mutineer"
	restricted_jobs = list("Facility Director")

/datum/antagonist/mutineer/New(var/no_reference)
	..()
	if(!no_reference)
		mutineers = src

/datum/antagonist/mutineer/proc/recruit()

/datum/antagonist/mutineer/can_become_antag(var/datum/mind/player)
	if(!..())
		return FALSE
	if(!istype(player.current, /mob/living/carbon/human))
		return FALSE
	if(M.special_role)
		return FALSE
	return 1

/*
	var/list/directive_candidates = get_directive_candidates()
	if(!directive_candidates || directive_candidates.len == 0)
		to_chat(world, "<span class='warning'>Mutiny mode aborted: no valid candidates for Directive X.</span>")
		return FALSE

	head_loyalist = pick(loyalist_candidates)
	head_mutineer = pick(mutineer_candidates)
	current_directive = pick(directive_candidates)


	// Returns an array in case we want to expand on this later.
	proc/get_head_loyalist_candidates()
		var/list/candidates[0]
		for(var/mob/loyalist in player_list)
			if(loyalist.mind && loyalist.mind.assigned_role == "Facility Director")
				candidates.Add(loyalist.mind)
		return candidates

	proc/get_head_mutineer_candidates()
		var/list/candidates[0]
		for(var/mob/mutineer in player_list)
			if(mutineer.client.prefs.be_special & BE_MUTINEER)
				for(var/job in command_positions - "Facility Director")
					if(mutineer.mind && mutineer.mind.assigned_role == job)
						candidates.Add(mutineer.mind)
		return candidates

	proc/get_directive_candidates()
		var/list/candidates[0]
		for(var/T in typesof(/datum/directive) - /datum/directive)
			var/datum/directive/D = new T(src)
			if (D.meets_prerequisites())
				candidates.Add(D)
		return candidates


	return 1

*/
