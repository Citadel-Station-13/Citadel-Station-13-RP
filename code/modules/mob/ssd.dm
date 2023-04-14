/**
 * "space sleep disorder" is the HRP term for someone who's logged out.
 *
 * people who just don't have minds do not count.
 * people who are AI-controlled never count.
 * people who are dead do not count.
 * adminghosted people do not count.
 */
/mob/proc/is_ssd()
	return ckey && isnull(client) && isnull(teleop) && !IS_DEAD(src)

/mob/living/is_ssd()
	return !isnull(ai_holder) && ..()

/**
 * basically, indicates that a player's gone, and there's no ai holder
 */
/mob/proc/is_ghosted()
	return !ckey

/mob/living/is_ghosted()
	return !isnull(ai_holder) && ..()

#warn this all is bad (above)

/**
 * update ssd overlay
 *
 * @params
 * * forced_state - if set, adds on TRUE and removes on FALSE, ignoring client status.
 */
/mob/proc/update_ssd_overlay(forced_state)
	var/want = isnull(forced_state)? is_ssd() : forced_state
	if(want && isnull(ssd_overlay))
		#warn impl
	else if(!want && !isnull(ssd_overlay))
		cut_overlay(ssd_overlay, TRUE)
	else
		// just update positoins
		cut_overlay(ssd_overlay, TRUE)
		#warn impl
		add_overlay(ssd_overlay, TRUE)
