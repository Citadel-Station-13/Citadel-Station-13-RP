/**
 * are we in critical?
 *
 * todo: this is silly, brainmed when
 */
/mob/proc/is_in_critical()
	return FALSE

/**
 * update health
 */
/mob/proc/update_health()
	return

/**
 * update stat, return new stat
 */
/mob/proc/update_stat()
	. = initial(stat)
	if(. != stat)
		set_stat(.)

/**
 * set stat
 * should only be called internally by update_stat().
 */
/mob/proc/set_stat(new_stat)
	stat = new_stat
