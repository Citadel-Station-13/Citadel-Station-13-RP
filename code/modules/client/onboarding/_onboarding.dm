/**
 * runs the gauntlet of checks we use on join
 *
 * client should already be logged to DB at this point.
 */
/client/proc/onboarding()
	security_checks()
	panic_bunker()
	age_verification()
