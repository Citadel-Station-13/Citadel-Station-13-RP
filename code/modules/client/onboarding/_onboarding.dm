/**
 * runs the gauntlet of checks we use on join
 *
 * client should already be logged to DB at this point.
 */
/client/proc/onboarding()
	if(!security_checks())
		return FALSE
	if(!panic_bunker())
		return FALSE
	if(!age_verification())
		return FALSE
	return TRUE

#warn impl all
