//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/ai_holder/dynamic
	/// an atom considered to be our home. does not need to be a turf; if it's not a turf
	/// we will occasionally recalculate move to be near it while idling
	///
	/// overridden by:
	/// * forced navigation
	/// * patrol routes
	/// * combat, except in hold position
	/// * combat, during hold position, will result in us using this as our combat locality.
	///
	/// if we are going home and we fail to pathfind home, we will drop our home destination.
	var/atom/home
	/// tiles we can wander around home
	var/home_wander_distance = 14
	/// don't stray too far from home even in combat
	/// disengagement will use **fleeing** behavior.
	var/home_return_disengagement = FALSE
	/// combat disengagement distance; if null, this is home_wander_distance
	var/home_disengagement_distance
	/// combat disengagement probability per tick per tick per tile away from disengagement distance
	var/home_disengagement_escalation = 2.5

/datum/ai_holder/dynamic/proc/go_home()
	if(!home)
		return FALSE
	#warn disengage if in combat
	if(!set_navigation(home))
		return FALSE
	return TRUE

/datum/ai_holder/dynamic/proc/on_home_pathfind_end(cancelled, failed)
	if(failed)
		home = null
