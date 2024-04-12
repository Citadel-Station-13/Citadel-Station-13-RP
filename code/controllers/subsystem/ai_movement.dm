//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/// if we fall behind this much, we reset buckets
#define BUCKET_CATASTROPHIC_LAG_THRESHOLD AI_SCHEDULING_LIMIT
/// this much time is allowed to be in buckets (scheduling limit)
#define BUCKET_INTERVAL AI_SCHEDULING_LIMIT
/// this many buckets are kept
#define BUCKET_AMOUNT round(BUCKET_INTERVAL * 0.1 * world.fps)
/// distribute ais over this many seconds during resets.
#define BUCKET_RESET_DISTRIBUTION (3 SECONDS)

/**
 * Handles processing /datum/ai_movement's.
 */
SUBSYSTEM_DEF(ai_movement)
	name = "AI Movement"
	subsystem_flags = SS_TICKER
	priority = FIRE_PRIORITY_AI_MOVEMENT

	/// ais that are moving using a movement handler right now
	var/list/datum/ai_holder/moving_ais
	/// tick buckets
	var/list/datum/ai_holder/buckets
	/// the tickrate our buckets were designed for
	var/bucket_fps
	/// current bucket position
	var/bucket_index
	/// last world.time we ticked
	///
	/// or more practically,
	/// the world.time of bucket_index
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

// todo: need some eyes on this to make sure it's working fine and with
//       the least amount of overhead possible.
/datum/controller/subsystem/ai_movement/fire()
	// get local references for speed
	var/list/buckets = src.buckets
	// if we're too far behind, reset; we don't have a second queue unlike timers
	if((world.time - bucket_time) > BUCKET_CATASTROPHIC_LAG_THRESHOLD)
		rebuild()
		stack_trace("ai_movement subsystem rebuilt buckets due to running too far behind.")
		return
	// setup loop
	var/processed_buckets
	var/processing_index = bucket_index
	var/unwrapped_index_of_now = bucket_index + round(DS2TICKS(world.time - bucket_time))
	var/bucket_amount = length(buckets)
	var/processed_buckets = 0
	for(var/iter in 1 to round(DS2TICKS(world.time - bucket_time)))
		var/datum/ai_holder/head = buckets[processing_index]
		while(head)
			if(MC_TICK_CHECK)
				break
			// eject from bucket
			if(head.movement_bucket_next == head)
				// ourselves = we're the only one
				buckets[processing_index] = null
			else
				// there's another
				buckets[processing_index] = head.movement_bucket_next
				// stitch those two together
				head.movement_bucket_next.movement_bucket_prev = head.movement_bucket_prev
				head.movement_bucket_prev.movement_bucket_next = head.movement_bucket_next
			var/reschedule_delay = head.move(++head.movement_cycle)
			if(reschedule_delay)
				// re-schedule to the necessary bucket
				var/next_bucket = (DS2TICKS(reschedule_delay) + unwrapped_index_of_now) % bucket_amount
				// insert
				if(isnull(buckets[next_bucket]))
					// we're the only one
					head.movement_bucket_next = head.movement_bucket_prev = head
				else
					// there's another
					var/datum/ai_holder/existing = buckets[next_bucket]
					buckets[next_bucket] = head
					head.movement_bucket_next = existing
					head.movement_bucket_prev = existing.movement_bucket_prev
					head.movement_bucket_next.movement_bucket_prev = head
					head.movement_bucket_prev.movement_bucket_next = head
				head.movement_bucket_position = next_bucket
			else
				// eject entirely
				head.movement_ticking = FALSE
				head.movement_bucket_next = head.movement_bucket_prev = head.movement_bucket_position = null
				head.movement_cycle = 0

		// if we successfully moved past..
		if(state != SS_PAUSING)
			processing_index += 1
			if(processing_index > bucket_amount)
				processing_index = 1
			processed_buckets += 1
		else
			break

	bucket_time += TICKS2DS(processed_buckets)
	bucket_index = processing_index

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
	if(length(moving_ais) > round((BUCKET_RESET_DISTRIBUTION / 10) * world.fps - 1))
		buckets = new /list(BUCKET_AMOUNT)
		var/position = 1
		for(var/datum/ai_holder/holder as anything in moving_ais)
			if(!istype(holder))
				moving_ais -= holder
				stack_trace("bad holder found")
				continue
			// doubly linked list inject
			if(!isnull(buckets[position]))
				var/datum/ai_holder/existing = buckets[position]
				holder.movement_bucket_next = existing.movement_bucket_next
				existing.movement_bucket_next = holder
				holder.movement_bucket_prev = existing
				holder.movement_bucket_next.movement_bucket_prev = holder
			else
				buckets[position] = holder
				holder.movement_bucket_next = holder.movement_bucket_prev = holder
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
	var/balancing = allow_load_balancing? min(rand(load_balancing_low, load_balancing_high), BUCKET_INTERVAL - delay) : delay
	var/bucket = round(max(1, (delay + balancing) * 0.1 * world.fps)) + bucket_index
	// modulo it by total buckets
	bucket = (bucket % BUCKET_AMOUNT)
	// register in bucket
	var/datum/ai_holder/existing = buckets[bucket]
	if(isnull(existing))
		buckets[bucket] = holder
		holder.movement_bucket_next = holder.movement_bucket_prev = holder
	else
		holder.movement_bucket_next = existing
		holder.movement_bucket_prev = existing.movement_bucket_prev
		existing.movement_bucket_prev = holder
		holder.movement_bucket_prev.movement_bucket_next = holder
	holder.movement_bucket_position = bucket
	return TRUE

/datum/controller/subsystem/ai_movement/proc/unregister_moving(datum/ai_holder/holder)
	if(!holder.movement_ticking)
		return FALSE
	var/datum/ai_holder/next
	if(holder.movement_bucket_next != holder)
		// if we're not linking to ourselves, eject us from the linked list
		next = holder.movement_bucket_next
		next.movement_bucket_prev = holder.movement_bucket_prev
		holder.movement_bucket_prev.movement_bucket_next = next
		if(buckets[holder.movement_bucket_position] == holder)
			buckets[holder.movement_bucket_position] = next
	else
		// if we are linking to ourselves, we must be the head
		buckets[holder.movement_bucket_position] = next
	holder.movement_bucket_prev = holder.movement_bucket_next = holder.movement_bucket_position = null
	holder.movement_ticking = FALSE
	holder.movement_cycle = 0
	return TRUE

#undef BUCKET_CATASTROPHIC_LAG_THRESHOLD
#undef BUCKET_AMOUNT
#undef BUCKET_INTERVAL
#undef BUCKET_RESET_DISTRIBUTION
