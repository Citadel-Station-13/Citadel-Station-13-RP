//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/// if we fall behind this much, we reset buckets
#define BUCKET_CATASTROPHIC_LAG_THRESHOLD (10 SECONDS)
/// this much time is allowed to be in buckets (scheduling limit)
#define BUCKET_INTERVAL (30 SECONDS)
/// this many buckets are kept
#define BUCKET_AMOUNT round(BUCKET_INTERVAL * 0.1 * world.fps)
/// distribute ais over this many seconds during resets.
#define BUCKET_RESET_DISTRIBUTION (3 SECONDS)

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

	/// pathfinder instances by type
	var/list/ai_pathfinders

/datum/controller/subsystem/ai_movement/Initialize()
	init_ai_pathfinders()
	moving_ais = list()
	rebuild()
	return ..()

/datum/controller/subsystem/ai_movement/on_ticklag_changed(old_ticklag, new_ticklag)
	rebuild()
	return ..()

/datum/controller/subsystem/ai_movement/proc/init_ai_pathfinders()
	ai_pathfinders = list()
	for(var/datum/ai_pathfinder/path as anything in subtypesof(/datum/ai_pathfinder))
		if(initial(path.abstract_type) == path)
			continue
		ai_pathfinders[path] = new path

/datum/controller/subsystem/ai_movement/fire()
	#warn impl

/**
 * perform error checking
 * rebuild all buckets
 */
/datum/controller/subsystem/ai_movement/proc/rebuild()
	bucket_fps = world.fps
	bucket_index = 1
	bucket_time = world.time
	// because early-calling ais isn't harmful, let's just distribute them over a bit of time
	shuffle_inplace(moving_ais)
	// if there's more ais than distribution threshold
	if(length(moving_ais) > round((BUCKET_RESET_DISTRIBUTION / 10) * fps - 1))
		buckets = new /list(BUCKET_AMOUNT)
		var/position = 1
		for(var/datum/ai_holder/holder as anything in moving_ais)
			if(!istype(holder))
				moving_ais -= holder
				stack_trace("bad holder found")
				continue
			if(!isnull(buckets[position]))
				var/datum/ai_holder/existing = buckets[position]
				// doubly linked list inject
				holder.movement_bucket_next = existing.movement_bucket_next
				existing.movement_bucket_next = holder
				holder.movement_bucket_prev = existing
				holder.movement_bucket_next.movement_bucket_prev = holder
			else
				buckets[position] = holder
			++position
			if(position > length(buckets))
				position = 1
	// else just use the existing list
	else
		buckets = moving_ais.Copy()
		buckets.len = BUCKET_AMOUNT

/**
 * start moving a holder
 *
 * @params
 * * delay - initial delay before moving
 * * allow_load_balancing - does this need to be a strict delay? if not, leave this on.
 * * load_balancing_low - low value for rand() of how long to delay ontop of given delay
 * * load_balancing_high - high value for rand() of how long to delay ontop of given delay.
 */
/datum/controller/subsystem/ai_movement/proc/register_moving(datum/ai_holder/holder, delay, allow_load_balancing = TRUE, load_balancing_low = 0, load_balancing_high = 2)
	if(holder.movement_ticking)
		return FALSE
	// allow load balancing basically just tells ai movement that it can delay us by a
	// tick or two to spread the work over more ticks.
	//
	// the important thing is this can only happen at the start,
	// if the randomization happened mid run it might mess with mob movement timing,
	// as mob movement is not tolerant to 'early' fires.
	var/balancing = allow_load_balancing? min(rand(load_balancing_low, load_balancing_high), BUCKET_INTERVAL - delay)
	var/bucket = round(max(1, (delay + balancing) * 0.1 * world.fps))
	#warn redo this above

	#warn impl

/datum/controller/subsystem/ai_movement/proc/unregister_moving(datum/ai_holder/holder)
	if(!holder.movement_ticking)
		return FALSE
	var/datum/ai_holder/next
	if(holder.movement_bucket_next)
		next = holder.movement_bucket_next
		next.movement_bucket_prev = holder.movement_bucket_prev
		holder.movement_bucket_prev.movement_bucket_next = next
		buckets[holder.movement_bucket_position] = next
	if(buckets[holder.movement_bucket_position] == holder)
		buckets[holder.movement_bucket_position] = next
	holder.movement_bucket_prev = null
	holder.movement_bucket_next = null
	holder.movement_bucket_position = null
	holder.movement_ticking = FALSE
	holder.movement_cycle = 0
	return TRUE

#undef BUCKET_CATASTROPHIC_LAG_THRESHOLD
#undef BUCKET_AMOUNT
#undef BUCKET_INTERVAL
#undef BUCKET_RESET_DISTRIBUTION
