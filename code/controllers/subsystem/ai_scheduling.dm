//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/// if we fall behind this much, we reset buckets
#define BUCKET_CATASTROPHIC_LAG_THRESHOLD AI_SCHEDULING_LIMIT
/// this many buckets are kept
#define BUCKET_AMOUNT (AI_SCHEDULING_LIMIT / world.tick_lag)

/**
 * Handles ticking AI holders
 */
SUBSYSTEM_DEF(ai_scheduling)
	name = "AI Holders"
	subsystem_flags = NONE
	priority = FIRE_PRIORITY_AI_SCHEDULING

	/// rolling bucket list; these hold the head node of linked /datum/ai_callback's
	var/tmp/list/scheduler_buckets
	/// world.time of bucket head
	var/bucket_position
	/// index of bucket head
	var/bucket_index
	/// world.fps buckets were made for
	var/bucket_fps

	/// global ai_lexicon instances
	var/list/ai_lexicons

/datum/controller/subsystem/ai_scheduling/Initialize()
	rebuild()
	return ..()

/datum/controller/subsystem/ai_scheduling/on_ticklag_changed(old_ticklag, new_ticklag)
	rebuild()
	return ..()

/datum/controller/subsystem/ai_scheduling/fire(resumed)
	#warn impl

/datum/controller/subsystem/ai_scheduling/Recover()
	rebuild()
	return ..()

/datum/controller/subsystem/ai_scheduling/proc/schedule_callback(datum/ai_callback/callback, delay)
	// determine bucket without wrapping
	var/bucket = bucket_index + round(max(1, DS2TICKS(delay)) + DS2TICKS(world.time - bucket_position))
	// modulo it by total buckets to wrap
	bucket = (bucket % length(scheduler_buckets))
	// inject
	if(isnull(buckets[bucket]))
		// nothing's there, we're there
		buckets[bucket] = callback
	else
		// put it before
		callback.next = buckets[bucket]
		buckets[bucket] = callback

/**
 * perform error checking
 * rebuild all buckets
 */
/datum/controller/subsystem/ai_scheduling/proc/rebuild()
	bucket_position = world.time
	bucket_index = 1
	bucket_fps = world.fps
	// we don't give a crap about recovered scheduled events; shrimply not our issue
	// if you change ticklag midgame all AIs should be rescheduling anyways.
	scheduler_buckets = new /list(BUCKET_AMOUNT)

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
