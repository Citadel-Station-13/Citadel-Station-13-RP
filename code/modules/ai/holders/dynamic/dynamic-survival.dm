//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/ai_holder/dynamic
	/// currently taking cover at
	var/turf/taking_cover
	/// cached potential covers nearby
	var/list/turf/potential_cover
	/// last cover scan
	var/last_cover_scan
	/// enemy is hitting us from behind cover! disable cover until this world time
	var/no_cover_until

#warn impl all

/**
 * used to suspend taking cover if someone's using an object-penetrating weapon
 */
/datum/ai_holder/dynamic/proc/suspend_cover(for_how_long)
	#warn impl

/**
 * compute & go to cover if possible
 */
/datum/ai_holder/dynamic/proc/take_cover()
	#warn impl

/**
 * Find nearest tile counted as cover
 */
/datum/ai_holder/dynamic/proc/search_for_cover()
	#warn impl
