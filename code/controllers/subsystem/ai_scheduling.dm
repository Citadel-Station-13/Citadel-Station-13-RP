//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/// if we fall behind this much, we reset buckets
#define BUCKET_CATASTROPHIC_LAG_THRESHOLD AI_SCHEDULING_TOLERANCE
/// this many buckets are kept
#define BUCKET_AMOUNT ((AI_SCHEDULING_TOLERANCE + AI_SCHEDULING_LIMIT) * 0.1 * world.fps)

/**
 * Handles ticking AI holders
 */
SUBSYSTEM_DEF(ai_scheduling)
	name = "AI Scheduling"
	subsystem_flags = NONE
	priority = FIRE_PRIORITY_AI_SCHEDULING
	init_order = INIT_ORDER_AI_SCHEDULING
	init_stage = INIT_STAGE_EARLY
	wait = 0

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

/datum/controller/subsystem/ai_scheduling/Initialize()
	rebuild()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/ai_scheduling/on_ticklag_changed(old_ticklag, new_ticklag)
	rebuild()
	return ..()

/datum/controller/subsystem/ai_scheduling/fire(resumed)
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
	// go through buckets
	for(buckets_processed in 0 to buckets_needing_processed)
		var/bucket_offset = ((head_index + buckets_processed) % bucket_amount) + 1
		var/datum/ai_callback/being_processed
		while((being_processed = buckets[bucket_offset]))
			being_processed.invoke()
			buckets[bucket_offset] = being_processed.next
			if(MC_TICK_CHECK)
				break
		if(state != SS_RUNNING)
			// got tick check'd; break so we stay on this bucket for now
			// otherwise we'd go forwards 1 and drop this bucket
			break

	bucket_head_index = ((bucket_head_index + buckets_processed) % length(buckets)) + 1
	bucket_head_time = bucket_head_time + TICKS2DS(buckets_processed)

/datum/controller/subsystem/ai_scheduling/Recover()
	rebuild()
	return ..()

/datum/controller/subsystem/ai_scheduling/proc/schedule_callback(datum/ai_callback/callback, delay)
	// determine bucket without wrapping
	var/raw_head_index = bucket_head_index + round(DS2TICKS(world.time - bucket_head_time))
	// modulo it by total buckets to wrap
	var/bucket = (raw_head_index % length(buckets)) + 1
	// inject
	var/datum/ai_callback/existing = buckets[bucket]
	if(existing)
		// put it before
		callback.next = existing
	buckets[bucket] = callback

/**
 * perform error checking
 * rebuild all buckets
 */
/datum/controller/subsystem/ai_scheduling/proc/rebuild()
	bucket_head_time = world.time
	bucket_head_index = 0
	bucket_fps = world.fps
	// we don't give a crap about recovered scheduled events; shrimply not our issue
	// if you change ticklag midgame all AIs should be rescheduling anyways.
	buckets = new /list(BUCKET_AMOUNT)

#undef BUCKET_CATASTROPHIC_LAG_THRESHOLD
#undef BUCKET_AMOUNT

/**
 * ! Hi. This datum has special GC behavior. Thus we only make it for one purpose that I selected
 * ! where it will not cause a memory leak. If you use it for other purposes, you will cause
 * ! problems, and we certainly wouldn't want to have that, right?
 *
 * * Not to mention this datum is specifically secured in a specific way to not be able to be
 *   hijacked by admin proccalls; infact it's more secure than normal /datum/callback.
 * * So, do not fuck with it.
 *
 * List of things allowed to use this:
 * * /datum/ai_holder
 * * /datum/ai_network
 *
 * Quirks:
 * * This will never sleep on invocation. If the called proc sleeps, we blow right past.
 * * Try to not have the called proc be ridiculously expensive as we are on a very fast-firing subsystem.
 */
/datum/ai_callback
	var/proc_ref
	var/list/arguments
	var/datum/parent
	/// next
	var/datum/ai_callback/next

/datum/ai_callback/New(proc_ref, list/arguments, datum/parent)
	src.proc_ref = proc_ref
	src.arguments = arguments
	src.parent = parent

/datum/ai_callback/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	arguments = parent = next = null
	// if this leaks, L; don't fuck it up!
	return QDEL_HINT_IWILLGC

/datum/ai_callback/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	return FALSE // no thanks bucko

/datum/ai_callback/CanProcCall(procname)
	return FALSE // no thanks bucko

/datum/ai_callback/proc/invoke()
	SHOULD_NOT_SLEEP(TRUE)
	set waitfor = FALSE
	call(parent, proc_ref)(arglist(arguments))
