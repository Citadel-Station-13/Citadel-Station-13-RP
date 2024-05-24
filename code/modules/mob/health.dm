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
/mob/proc/update_stat(forced, update_mobility = TRUE)
	. = forced || initial(stat)
	if(. != stat)
		set_stat(., update_mobility)

/**
 * set stat
 * should only be called internally by update_stat().
 */
/mob/proc/set_stat(new_stat, update_mobility = TRUE)
	if(stat == new_stat)
		return FALSE
	var/was_dead = IS_DEAD(src)
	var/old_stat = stat
	stat = new_stat
	if(old_stat != new_stat)
		mob_list_update_stat(old_stat, new_stat)
	var/is_dead = IS_DEAD(src)
	mobility_flags = (mobility_flags & ~(MOBILITY_IS_CONSCIOUS)) | (STAT_IS_CONSCIOUS(new_stat)? MOBILITY_IS_CONSCIOUS : NONE)
	if(!STAT_IS_CONSCIOUS(new_stat))
		facing_dir = null
	if(was_dead != is_dead)
		if(was_dead && !is_dead)
			living_mob_list += src
			dead_mob_list -= src
		else if(!was_dead && is_dead)
			living_mob_list -= src
			dead_mob_list += src
	if(update_mobility)
		update_mobility()
	update_hud_med_status()
	return TRUE

/**
 * brings a mob back to life
 *
 * @params
 * * force - ignore health and revive even if we'll immediately die again
 * * full_heal - fix everything we need to live
 */
/mob/proc/revive(force, full_heal)
	// full heal if requested
	if(full_heal)
		rejuvenate(TRUE)
	// flush playtimes
	SSplaytime.queue_playtimes(client)
	// set to conscious
	set_stat(CONSCIOUS)
	// immediately update to kick down if needed
	update_stat()
	return TRUE

/**
 * heals all damage on a mob. by default, only heals "basic" numerical / limb damage. see params for more.
 *
 * @param
 * * fix_missing - restore all organs we'd need to live, and all default organs (say, limbs) that we're missing
 * * reset_to_slot - wipe all state and reset back to the character slot.
 */
/mob/proc/rejuvenate(fix_missing, reset_to_slot)
	return TRUE
