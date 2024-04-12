//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/ai_holder/dynamic
	/// our simulated reflex time in ds
	/// overridden if superhuman reflexes is enabled in cheating.
	var/reaction_time_center = 3.25 // the reaction time of an Above Average Gamer
	/// randomization; we use simple rand() for speed
	var/reaction_time_rand = 0.75 // +- 75

/**
 * Like schedule() but using our reaction time
 */
/datum/ai_holder/dynamic/proc/schedule_reaction(proc_ref, list/arguments)
	// "because silicons is satan" - thefinalpotato
	return schedule(
		(ai_cheat_flags & AI_CHEAT_MACHINE_REFLEXES)? 0 : max(
			0,
			reaction_time_center + rand(
				-reaction_time_rand,
				reaction_time_rand
			)
		),
		proc_ref,
		arguments,
	)
