//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/// if we fall behind this much, we reset buckets
#define BUCKET_CATASTROPHIC_LAG_THRESHOLD (10 SECONDS)
/// this many buckets are kept
#define BUCKET_INTERVAL (30 SECONDS)

/**
 * Handles processing /datum/ai_movement's.
 */
SUBSYSTEM_DEF(ai_movement)
	name = "AI Movement"

	/// ais that are moving using a movement handler right now
	var/list/datum/ai_holder/moving_ais
	/// tick buckets
	var/list/datum/ai_holder/buckets
	/// the tickrate our buckets were designed for
	var/bucket_fps
	/// current bucket position
	var/bucket_index
	/// last world.time we ticked
	var/bucket_time

	#warn impl

	/// pathfinder instances by type
	var/list/ai_pathfinders

/datum/controller/subsystem/ai_movement/Initialize()
	init_ai_pathfinders()
	moving_ais = list()
	rebuild()
	#warn a

/datum/controller/subsystem/ai_movement/on_ticklag_changed(old_ticklag, new_ticklag)
	rebuild()
	return ..()

/datum/controller/subsystem/ai_movement/proc/init_ai_pathfinders()
	ai_pathfinders = list()
	for(var/datum/ai_pathfinder/path as anything in subtypesof(/datum/ai_pathfinder))
		if(initial(path.abstract_type) == path)
			continue
		ai_pathfinders[path] = new path

/**
 * perform error checking
 * rebuild all buckets
 */
/datum/controller/subsystem/ai_movement/proc/rebuild()
	#warn impl

#undef BUCKET_CATASTROPHIC_LAG_THRESHOLD
#undef BUCKET_INTERVAL
