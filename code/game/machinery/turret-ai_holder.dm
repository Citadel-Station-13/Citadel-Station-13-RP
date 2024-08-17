/**
 * Turret AI
 */
/datum/ai_holder/turret
	agent_type = /obj/machinery/porta_turret

	/// a list of targets we're currently engaging
	var/tmp/list/engaging_targets

/datum/ai_holder/turret/on_enable()
	..()
	var/obj/machinery/porta_turret/turret = agent
	#warn ticking

/**
 * Returns a list of prioritized (index 1 = most important) targets
 *
 * * Optimized for speed, not for accuracy.
 */
/datum/ai_holder/turret/proc/continuous_evaluation()
