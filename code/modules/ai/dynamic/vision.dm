//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/ai_holder/dynamic
	/// vision range
	var/vision_range
	/// darksight range
	var/darksight_range
	/// darksight FOV define
	var/darksight_fov
	/// lumcount for a tile to be considered visible without darksight
	var/darksight_lumcount = LIGHT_THRESHOLD_MOB_AI_UNSEEN

/datum/ai_holder/dynamic/imprint_from_agent(atom/movable/agent)
	..()
	#warn impl

/datum/ai_holder/dynamic/proc/can_see(atom/movable/entity, check_los)
	var/their_dist = get_dist(agent, entity)
	if(their_dist > vision_range && !(cheat_flags & AI_CHEAT_FARSIGHT))
		return FALSE
	var/turf/T = get_turf(entity)
	if(!(cheat_flags & AI_CHEAT_NIGHTVISION) && T.get_lumcount() < darksight_lumcount && (their_dist > darksight_range || !check_darksight_fov(entity)))
		return FALSE
	return (check_los == TRUE)? check_los(entity) : TRUE

/datum/ai_holder/dynamic/proc/check_darksight_fov(atom/movable/entity)
	// wip
	return TRUE

/datum/ai_holder/dynamic/proc/check_los(atom/movable/entity)
	#warn impl
