//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/// if we fall behind this much, we reset buckets
#define BUCKET_CATASTROPHIC_LAG_THRESHOLD AI_SCHEDULING_TOLERANCE
/// this many buckets are kept
#define BUCKET_AMOUNT ((AI_SCHEDULING_TOLERANCE + AI_SCHEDULING_LIMIT) * 0.1 * world.fps)
/// this much time is allowed to be in buckets (scheduling limit)
#define BUCKET_INTERVAL AI_SCHEDULING_LIMIT
/// distribute ais over this many seconds during resets.
#define BUCKET_RESET_DISTRIBUTION (3 SECONDS)

/**
 * Handles processing /datum/ai_movement's.
 */
SUBSYSTEM_DEF(ai_movement)
	name = "AI Movement"
	subsystem_flags = NONE
	priority = FIRE_PRIORITY_AI_MOVEMENT
	init_order = INIT_ORDER_AI_MOVEMENT
	init_stage = INIT_STAGE_EARLY
	wait = 0

	/// ais that are moving using a movement handler right now
	var/list/datum/ai_holder/moving_ais
	/// rolling bucket list; these hold the head node of linked ai_holders.
	///
	/// the head bucket is the last one we processed
	/// after subsystem ticks, if it isn't interrupted, the head bucket
	/// should be empty.
	///
	/// placing stuff onto head bucket = run immediately
	/// placing stuff onto next bucket = run the tick after head
	var/tmp/list/buckets
	/// world.time of bucket head
	var/bucket_head_time
	/// index of bucket head
	var/bucket_head_index
	/// world.fps buckets were made for
	var/bucket_fps

	/// pathfinder instances by type
	var/list/ai_pathfinders

/datum/controller/subsystem/ai_movement/Initialize()
	moving_ais = list()
	rebuild()
	init_ai_pathfinders()
	return SS_INIT_SUCCESS

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
	if(bucket_fps != world.fps)
		subsystem_log("rebuilding buckets - world.fps [world.fps] != [bucket_fps]")
		rebuild()
		return
	var/elapsed = world.time - bucket_head_time
	if((elapsed) > BUCKET_CATASTROPHIC_LAG_THRESHOLD)
		subsystem_log("rebuilding buckets - lagged too far behind")
		rebuild()
		return
	// cache for speed
	var/list/buckets = src.buckets
	var/buckets_needing_processed = round(elapsed * 0.1 * world.fps)
	var/buckets_processed
	var/bucket_amount = length(buckets)
	var/head_index = bucket_head_index
	var/now_index_raw = bucket_head_index + round(DS2TICKS(elapsed))
	// go through buckets
	for(buckets_processed in 0 to buckets_needing_processed)
		var/bucket_offset = ((head_index + buckets_processed) % bucket_amount) + 1
		var/datum/ai_holder/being_processed
		while((being_processed = buckets[bucket_offset]))
			var/reschedule_delay = being_processed.move(++being_processed.movement_cycle)
			// check if we are still ticking; if not, we got ejected, so we abort as we don't need to eject or insert again
			if(buckets[bucket_offset] == being_processed)
				if(reschedule_delay)
					// eject; we don't change being_processed.ticking_(next|previous)
					if(being_processed.movement_bucket_next == being_processed)
						// this was the only holder in the bucket
						buckets[bucket_offset] = null
					else
						// this was not the only holder in the bucket, stitch it back together after the ejection.
						buckets[bucket_offset] = being_processed.movement_bucket_next
						being_processed.movement_bucket_next.movement_bucket_prev = being_processed.movement_bucket_prev
						being_processed.movement_bucket_prev.movement_bucket_next = being_processed.movement_bucket_next
					// insert; we now set its ticking_(next|previous)
					// note that we don't do catchup
					var/inject_offset = ((now_index_raw + round(DS2TICKS(reschedule_delay))) % bucket_amount) + 1
					if(buckets[inject_offset])
						var/datum/ai_holder/being_injected = buckets[inject_offset]
						being_processed.movement_bucket_next = being_injected
						being_processed.movement_bucket_prev = being_injected.movement_bucket_prev
						being_processed.movement_bucket_prev.movement_bucket_next = being_processed
						being_processed.movement_bucket_next.movement_bucket_prev = being_processed
					else
						buckets[inject_offset] = being_processed
						being_processed.movement_bucket_next = being_processed.movement_bucket_prev = being_processed
					being_processed.movement_bucket_position = inject_offset
				else
					// get out if not rescheduling
					unregister_moving(being_processed)
			if(MC_TICK_CHECK)
				break
		if(state != SS_RUNNING)
			// got tick check'd; break so we stay on this bucket for now
			// otherwise we'd go forwards 1 and drop this bucket
			break

	bucket_head_index = ((bucket_head_index + buckets_processed) % length(buckets)) + 1
	bucket_head_time = bucket_head_time + TICKS2DS(buckets_processed)

/**
 * perform error checking
 * rebuild all buckets
 */
/datum/controller/subsystem/ai_movement/proc/rebuild()
	bucket_head_time = world.time
	bucket_head_index = 0
	bucket_fps = world.fps
	// because early-calling ais isn't harmful, let's just distribute them over a bit of time
	shuffle_inplace(moving_ais)
	// if there's more ais than distribution threshold
	if(length(moving_ais) > round(DS2TICKS(BUCKET_RESET_DISTRIBUTION)))
		buckets = new /list(BUCKET_AMOUNT)
		var/position = 1
		for(var/datum/ai_holder/holder as anything in moving_ais)
			if(!istype(holder))
				moving_ais -= holder
				stack_trace("bad holder found")
				continue
			// circular double-linked list inject
			if(!isnull(buckets[position]))
				var/datum/ai_holder/existing = buckets[position]
				holder.movement_bucket_next = existing.movement_bucket_next
				existing.movement_bucket_next = holder
				holder.movement_bucket_prev = existing
				holder.movement_bucket_next.movement_bucket_prev = holder
			else
				buckets[position] = holder
				holder.movement_bucket_next = holder.movement_bucket_prev = holder
			holder.movement_bucket_position = position
			++position
			if(position > length(buckets))
				position = 1
	// else just use the existing list
	else
		buckets = moving_ais.Copy()
		buckets.len = BUCKET_AMOUNT
		for(var/i in 1 to length(moving_ais))
			var/datum/ai_holder/holder = buckets[i]
			holder.movement_bucket_next = holder.movement_bucket_prev = holder
			holder.movement_bucket_position = i

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
	var/balanced = allow_load_balancing? delay + rand(load_balancing_low, load_balancing_high) : delay
	var/bucket = round(bucket_head_index + max(0, DS2TICKS(balanced + (world.time - bucket_head_time))))
	// modulo it by total buckets
	bucket = (bucket % length(buckets)) + 1
	// register in bucket
	var/datum/ai_holder/existing = buckets[bucket]
	buckets[bucket] = holder
	if(isnull(existing))
		holder.movement_bucket_next = holder.movement_bucket_prev = holder
	else
		holder.movement_bucket_next = existing
		holder.movement_bucket_prev = existing.movement_bucket_prev
		existing.movement_bucket_prev = holder
		holder.movement_bucket_prev.movement_bucket_next = holder
	holder.movement_bucket_position = bucket
	holder.movement_ticking = TRUE
	holder.movement_cycle = 0
	moving_ais += holder
	return TRUE

/datum/controller/subsystem/ai_movement/proc/unregister_moving(datum/ai_holder/holder)
	if(!holder.movement_ticking)
		return FALSE
	var/datum/ai_holder/next
	if(holder.movement_bucket_position)
		if(holder.movement_bucket_next != holder)
			// if we're not linking to ourselves, eject us from the linked list
			next = holder.movement_bucket_next
			next.movement_bucket_prev = holder.movement_bucket_prev
			holder.movement_bucket_prev.movement_bucket_next = next
			if(buckets[holder.movement_bucket_position] == holder)
				buckets[holder.movement_bucket_position] = next
		else
			// if we are linking to ourselves, we must be the head
#ifdef CF_AI_HOLDER_DEBUG_ASSERTIONS
			ASSERT(buckets[holder.movement_bucket_position] == holder)
#endif
			buckets[holder.movement_bucket_position] = null
	holder.movement_bucket_prev = holder.movement_bucket_next = holder.movement_bucket_position = null
	holder.movement_ticking = FALSE
	holder.movement_cycle = 0
	moving_ais -= holder
	return TRUE

#undef BUCKET_CATASTROPHIC_LAG_THRESHOLD
#undef BUCKET_AMOUNT
#undef BUCKET_INTERVAL
#undef BUCKET_RESET_DISTRIBUTION
