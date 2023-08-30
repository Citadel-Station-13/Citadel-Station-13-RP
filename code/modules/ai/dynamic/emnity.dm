//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/ai_holder/dynamic
	/// emnity list ; kept sorted, direct references but should always prune eventually
	/// as this is cleared before we go to sleep/noncombat/etc
	/// entity associated to numerical value.
	var/list/emnity_tracked

/**
 * Sets entity's emnity to the minimum priority given.
 */
/datum/ai_holder/dynamic/proc/provoke(atom/movable/entity, priority)
	#warn impl

/**
 * Sets entity's emnity to the maximum priority given or below.
 */
/datum/ai_holder/dynamic/proc/shirk(atom/movable/entity, priority)
	#warn impl

/**
 * Sets entity's emnity to its current plus the given priority.
 */
/datum/ai_holder/dynamic/proc/increase_emnity(atom/movable/entity, priority)
	#warn impl

/**
 * Reduces entity's emnity to its current minus the given priority
 */
/datum/ai_holder/dynamic/proc/decrease_emnity(atom/movable/entity, priority)
	#warn impl

/**
 * Called when highest emnity is set to something else
 * Values can be null (obviously) if it wasn't already attacking/no longer is attacking.
 */
/datum/ai_holder/dynamic/proc/emnity_retarget(atom/movable/old_target, atom/movable/new_target)
	return

/**
 * Get highest emnity
 */
/datum/ai_holder/dynamic/proc/emnity_top()
	return emnity_tracked?[1]
