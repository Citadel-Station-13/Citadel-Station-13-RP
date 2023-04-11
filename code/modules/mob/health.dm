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
 *
 * @params
 * * forced - misnomer; this is not always respected. this is used by child calls to be able to force itself to be unconscious without more snowflake than necessary. parent calls should not go higher than forced.
 * * update_mobility - update mobility after
 */
/mob/proc/update_stat(forced, update_mobility)
	. = forced || initial(stat)
	if(. != stat)
		set_stat(., update_mobility)

/**
 * set stat
 * should only be called internally by update_stat().
 */
/mob/proc/set_stat(new_stat, update_mobility)
	if(stat == new_stat)
		return
	stat = new_stat
	if(!STAT_IS_CONSCIOUS(new_stat))
		facing_dir = null
	if(update_mobility)
		update_mobility()
