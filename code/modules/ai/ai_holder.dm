/**
 * Somewhat mob-agnostic AI holders.
 */
/datum/ai_holder
	/// suspended? if so, we're entirely ignored by ai processing. this is not "dormant until provoked", this is "turned off".
	var/suspended = FALSE
	/// can only be added to this type - we can assume that our parent is this type, if this is set
	var/expected_type = /atom/movable

	#warn how does tg do their atom levels..

/datum/ai_holder/New(atom/movable/host)
	#warn impl

/datum/ai_holder/Destroy()
	suspend()

/datum/ai_holder/proc/suspend()
	if(suspended)
		return
	suspended = TRUE
	#warn impl

/datum/ai_holder/proc/resume()
	if(!suspended)
		return
	suspended = FALSE
	#warn impl
