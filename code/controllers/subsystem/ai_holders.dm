//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/// if we fall behind this much, we reset buckets
#define BUCKET_CATASTROPHIC_LAG_THRESHOLD AI_SCHEDULING_LIMIT
/// this many buckets are kept
#define BUCKET_AMOUNT (AI_SCHEDULING_LIMIT / world.tick_lag)

/**
 * Handles ticking AI holders
 */
SUBSYSTEM_DEF(ai_holders)
	name = "AI Holders"

	/// all ticking ai holders
	var/static/list/datum/ai_holder/active_holders
	/// rolling bucket list; these hold the head node of linked ai_holders.
	var/tmp/list/holder_buckets
	/// rolling bucket list; these hold the head node of linked /datum/ai_callback's
	var/tmp/list/scheduler_buckets
	/// world.time of bucket head
	var/bucket_position
	/// index of bucket head
	var/bucket_index

	/// global ai_lexicon instances
	var/list/ai_lexicons

/datum/controller/subsystem/ai_holders/Initialize()
	init_ai_lexicons()
	rebuild()
	return ..()

/datum/controller/subsystem/ai_holders/on_ticklag_changed(old_ticklag, new_ticklag)
	rebuild()
	return ..()

/datum/controller/subsystem/ai_holders/fire(resumed)
	#warn impl

/datum/controller/subsystem/ai_holders/Recover()
	rebuild()
	return ..()

/datum/controller/subsystem/ai_holders/proc/init_ai_lexicons()
	for(var/datum/ai_lexicon/path as anything in subtypesof(/datum/ai_lexicon))
		if(initial(path.abstract_type) == path)
			continue
		var/datum/ai_lexicon/created = new path
		ai_lexicons[path] = created

/datum/controller/subsystem/ai_holders/proc/bucket_insert(datum/ai_holder/holder)
	ASSERT(holder.ticking <= AI_SCHEDULING_LIMIT)
	#warn impl

/datum/controller/subsystem/ai_holders/proc/bucket_evict(datum/ai_holder/holder)
	ASSERT(holder.ticking_position)
	if(holder_buckets[holder.ticking_position] == holder)
		holder_buckets[holder.ticking_position] = holder.ticking_next
	holder.ticking_next = holder.ticking_previous = null

/datum/controller/subsystem/ai_holders/proc/schedule_callback(datum/ai_callback/callback)
	#warn impl

/**
 * perform error checking
 * rebuild all buckets
 */
/datum/controller/subsystem/ai_holders/proc/rebuild()
	// todo; recover active_holders as well maybe?
	holder_buckets = new /list(BUCKET_AMOUNT)
	// we don't give a crap about recovered scheduled events; shrimply not our issue
	// if you change ticklag midgame all AIs should be rescheduling anyways.
	scheduler_buckets = new /list(BUCKET_AMOUNT)
	for(var/datum/ai_holder/holder as anything in active_holders)
		if(!istype(holder))
			active_holders -= holder
			continue
		if(!holder.ticking)
			continue
		if(holder.ticking > AI_SCHEDULING_LIMIT)
			holder.ticking = null
			holder.ticking_position = null
			holder.ticking_next = null
			holder.ticking_previous = null
			continue
		#warn impl; stagger it out.
		holder.ticking_position = new_index
	#warn impl


#warn impl all

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
