//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/stargazer_mindnet_ability/health_scan
	id = "health_scan"
	name = "Probe"
	desc = "Attempt to sense the biological status of a mind's body."

	can_be_cooperated_while_unconscious = TRUE
	attunement_cooperative_threshold = 20
	attunement_forced_threshold = 45

	default_do_after = 2 SECONDS

#warn impl

/**
 * @return a datum with info, or null to reject.
 */
/datum/stargazer_mindnet_ability/health_scan/proc/run_scan(datum/stargazer_mindnet_exec/exec) as /datum/stargazer_mindnet_health_scan
	var/mob/resolved = exec.resolve_target_mob()
	if(!isliving(resolved))
		return null
	var/datum/stargazer_mindnet_health_scan/scan = new


	#warn impl


	return scan
