/**
 * various join systems
 */
SUBSYSTEM_DEF(onboarding)
	name = "Onboarding"
	subsystem_flags = SS_NO_FIRE

	//* vpn module
	/// threshold for blocking vpns
	var/vpn_threshold
	/// ip (as client.address form) to probability cache
	var/static/list/vpn_cache = list()

/datum/controller/subsystem/onboarding/proc/vpn_score(address)

/datum/controller/subsystem/onboarding/proc/vpn_check(address)
	return vpn_score(address) >= vpn_threshold

#warn impl all
