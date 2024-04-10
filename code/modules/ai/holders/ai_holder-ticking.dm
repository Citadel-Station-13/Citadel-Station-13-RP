//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/ai_holder
	/// what holder is running after us
	var/datum/ai_holder/ticking_next
	/// what holder is running before us
	var/datum/ai_holder/ticking_previous
	/// ticking registered; null or number for delay
	var/ticking
	/// cycles ticked; set back to 0 when ticking is stopped.
	var/ticking_cycles
	/// bucket position
	var/ticking_position

/**
 * Starts ticking
 *
 * Registers us in a doubly linked list while also shoving us into ai_holders subsystem active holders + the
 * correct bucket for our target cycle.
 */
/datum/ai_holder/proc/set_ticking(delay)
	ASSERT(delay > 0)
	ASSERT(delay <= AI_SCHEDULING_LIMIT)
	if(ticking > 0)
		SSai_holders.bucket_evict(src)
	ticking_cycles = 0
	ticking = delay
	SSai_holders.bucket_insert(src)

/**
 * Stops ticking
 *
 * Unregister us from the doubly linked list we're in and removes us from the ai_holders subsystem.
 */
/datum/ai_holder/proc/stop_ticking()
	if(!ticking)
		return
	SSai_holders.bucket_evict(src)
	ticking = null
	ticking_cycles = null

/**
 * Called by subsystem to tick this holder.
 */
/datum/ai_holder/proc/tick(cycles)
	return
