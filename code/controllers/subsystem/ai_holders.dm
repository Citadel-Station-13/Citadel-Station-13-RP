//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/// if we fall behind this much, we reset buckets
#define BUCKET_CATASTROPHIC_LAG_THRESHOLD AI_SCHEDULING_TOLERANCE
/// this many buckets are kept
#define BUCKET_AMOUNT ((AI_SCHEDULING_TOLERANCE + AI_SCHEDULING_LIMIT) * 0.1 * world.fps)

/**
 * Handles ticking AI holders
 */
SUBSYSTEM_DEF(ai_holders)
	name = "AI Holders"
	subsystem_flags = NONE
	priority = FIRE_PRIORITY_AI_HOLDERS
	init_order = INIT_ORDER_AI_HOLDERS
	init_stage = INIT_STAGE_EARLY
	wait = 0

	/// all ticking ai holders
	var/static/list/datum/ai_holder/active_holders
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

/datum/controller/subsystem/ai_holders/Initialize()
	active_holders = list()
	rebuild()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/ai_holders/on_ticklag_changed(old_ticklag, new_ticklag)
	rebuild()
	return ..()

/datum/controller/subsystem/ai_holders/Recover()
	rebuild()
	return ..()

/datum/controller/subsystem/ai_holders/fire(resumed)
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
			being_processed.tick(++being_processed.ticking_cycles)
			// check if we are still ticking; if not, we got ejected, so we abort as we don't need to eject or insert again
			if(buckets[bucket_offset] == being_processed)
				// eject; we don't change being_processed.ticking_(next|previous)
				if(being_processed.ticking_next == being_processed)
#ifdef CF_AI_HOLDER_DEBUG_ASSERTIONS
					ASSERT(buckets[bucket_offset] == being_processed)
#endif
					buckets[bucket_offset] = null
				else
					buckets[bucket_offset] = being_processed.ticking_next
					being_processed.ticking_next.ticking_previous = being_processed.ticking_previous
					being_processed.ticking_previous.ticking_next = being_processed.ticking_next
				// insert; we now set its ticking_(next|previous)
				// note that we don't do catchup
				var/inject_offset = ((now_index_raw + round(DS2TICKS(being_processed.ticking))) % bucket_amount) + 1
				if(buckets[inject_offset])
					var/datum/ai_holder/being_injected = buckets[inject_offset]
					being_processed.ticking_next = being_injected
					being_processed.ticking_previous = being_injected.ticking_previous
					being_processed.ticking_previous.ticking_next = being_processed
					being_processed.ticking_next.ticking_previous = being_processed
				else
					buckets[inject_offset] = being_processed
					being_processed.ticking_next = being_processed.ticking_previous = being_processed
				being_processed.ticking_position = inject_offset
			if(MC_TICK_CHECK)
				break
		if(state != SS_RUNNING)
			// got tick check'd; break so we stay on this bucket for now
			// otherwise we'd go forwards 1 and drop this bucket
			break

	bucket_head_index = ((bucket_head_index + buckets_processed) % length(buckets)) + 1
	bucket_head_time = bucket_head_time + TICKS2DS(buckets_processed)

/datum/controller/subsystem/ai_holders/proc/bucket_insert(datum/ai_holder/holder)
#ifdef CF_AI_HOLDER_DEBUG_ASSERTIONS
	ASSERT(holder.ticking <= AI_SCHEDULING_LIMIT)
	ASSERT(!holder.ticking_position)
#endif

	var/new_index = round(bucket_head_index + ((world.time - bucket_head_time) * 0.1 * world.fps) + rand(0, holder.ticking * 0.1 * world.fps))
	new_index = (new_index % length(buckets)) + 1
	var/datum/ai_holder/existing = buckets[new_index]
	if(existing)
		existing.ticking_next.ticking_previous = holder
		holder.ticking_next = existing.ticking_next
		holder.ticking_previous = existing
		existing.ticking_next = holder
	else
		buckets[new_index] = holder
		holder.ticking_next = holder.ticking_previous = holder
	holder.ticking_position = new_index

/datum/controller/subsystem/ai_holders/proc/bucket_evict(datum/ai_holder/holder)
	ASSERT(holder.ticking_position)
	// if we're linking to ourselves, we're the head of the linked list
	if(holder.ticking_next == holder)
#ifdef CF_AI_HOLDER_DEBUG_ASSERTIONS
		ASSERT(buckets[holder.ticking_position] == holder)
#endif
		buckets[holder.ticking_position] = null
	// else, eject from linked list
	else
		if(buckets[holder.ticking_position] == holder)
			buckets[holder.ticking_position] = holder.ticking_next
		holder.ticking_next.ticking_previous = holder.ticking_previous
		holder.ticking_previous.ticking_next = holder.ticking_next
	holder.ticking_next = holder.ticking_previous = holder.ticking_position = null

/**
 * perform error checking
 * rebuild all buckets
 */
/datum/controller/subsystem/ai_holders/proc/rebuild()
	bucket_head_time = world.time
	bucket_head_index = 1
	bucket_fps = world.fps
	// todo; recover active_holders as well maybe?
	buckets = new /list(BUCKET_AMOUNT)
	var/bucket_amount = length(buckets)
	for(var/datum/ai_holder/holder as anything in active_holders)
		if(!istype(holder))
			active_holders -= holder
			continue
		if(!holder.ticking || (holder.ticking > AI_SCHEDULING_LIMIT))
			holder.ticking = null
			holder.ticking_position = null
			holder.ticking_next = null
			holder.ticking_previous = null
			active_holders -= holder
			continue
		var/new_index = bucket_head_index + rand(0, round(holder.ticking * 0.1 * world.fps))
		new_index = (new_index % bucket_amount) + 1
		var/datum/ai_holder/existing = buckets[new_index]
		if(existing)
			existing.ticking_next.ticking_previous = holder
			holder.ticking_next = existing.ticking_next
			holder.ticking_previous = existing
			existing.ticking_next = holder
		else
			buckets[new_index] = holder
			holder.ticking_next = holder.ticking_previous = holder
		holder.ticking_position = new_index

#undef BUCKET_CATASTROPHIC_LAG_THRESHOLD
#undef BUCKET_AMOUNT
