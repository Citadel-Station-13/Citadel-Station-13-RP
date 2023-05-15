/**
 * special ai holders
 *
 * * can request to tick at a certain rate
 * * can request to go to sleep / wake up to save CPU
 *
 * this is great for one-off boss AI's.
 */
/datum/ai_holder/special
	/// current tick interval
	var/tick_interval = 0.5 SECONDS
	/// our blackboard - arbitrary data can be stored in here.
	var/list/blackboard = list()

	#warn impl all

/datum/ai_holder/special/proc/set_tick_interval(interval)
	#warn impl

/**
 * @return if we finished or got CHECK_TICK'd
 */
/datum/ai_holder/special/proc/tick(cycles)
	return FALSE
