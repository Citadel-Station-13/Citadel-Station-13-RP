/**
 * dynamic export system
 *
 * runs against cargo exports, determines money received and aftereffects.
 */
/datum/export
	/// priority - lower runs first
	var/priority = 0
	/// global: everyone gets this by default
	var/for_everyone = TRUE

#warn impl
