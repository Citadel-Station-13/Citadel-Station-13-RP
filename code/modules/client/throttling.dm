/**
 * checks if we're on cooldown
 * if not,
 * blocks next execution of hot verb for x seconds
 */
/client/proc/throttle_verb(time = world.tick_lag)
	if(verb_throttle > world.time)
		to_chat(src, SPAN_WARNING("Verb on cooldown."))
		return FALSE
	verb_throttle = world.time + time
	return TRUE
