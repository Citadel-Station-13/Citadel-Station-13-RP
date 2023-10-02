/**
 * job experience system
 */

//! wip

/**
 * immediate check for if someone has jexp bypass
 *
 * may return incorrect answer if datbase hasn't loaded; use has_jexp_bypass_blocking() to ensure it's loaded.
 */
/client/proc/has_jexp_bypass()
	SHOULD_NOT_SLEEP(TRUE)
	return !!(admin_datums[ckey] || (player.player_flags & PLAYER_FLAG_JEXP_EXEMPT))

/client/proc/has_jexp_bypass_blocking()
	player.block_on_available()
	return !!(admin_datums[ckey] || (player.player_flags & PLAYER_FLAG_JEXP_EXEMPT))

