//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/ai_holder/dynamic
	/// we are considered 'telegraphing' until a given world time, if set
	var/telegraphing_until
	/// telegraph level; we can be pre-empted by an inbound event of a higher tier
	var/telegraphing_priority
	/// we should not be moving during this telegraph
	var/telegraphing_without_moving
	/// we should not be acting during this telegraph
	var/telegraphing_without_acting
	/// telegraph id
	var/telegraphing_id
	/// telegraph id next
	var/static/telegraphing_id_next = 0

/**
 * attempts to interrupt a telegraph if there is any
 *
 * @return TRUE if we should proceed with our action, FALSE otherwise
 */
/datum/ai_holder/dynamic/proc/interrupt_telegraph(level = AI_DYNAMIC_TELEGRAPH_INTERRUPT)
	if(isnull(telegraphing_until))
		return TRUE
	if(telegraphing_priority >= level)
		return FALSE
	telegraphing_until = null
	return TRUE

/**
 * starts a telegraphed action
 *
 * * will interrupt earlier telegraph if level is higher.
 */
/datum/ai_holder/dynamic/proc/start_telegraph(delay, level, no_move, no_act)
	if(telegraphing_until && telegraphing_priority <= level)
		return FALSE
	if(!delay && !telegraphing_until)
		return TRUE
	cancel_navigation()
	telegraphing_until = world.time + delay
	telegraphing_priority = level
	telegraphing_without_acting = no_act
	telegraphing_without_moving = no_move
	// im sorry
	telegraphing_id = (telegraphing_id_next = ((telegraphing_id_next + 1) % SHORT_REAL_LIMIT))
	return TRUE

/**
 * basically an ai's do_after().
 */
/datum/ai_holder/dynamic/proc/telegraph(delay, level, no_move, no_act, atom/target, mobility_flags, max_distance = 1)
	if(!interrupt_telegraph(level))
		return FALSE
	var/static/datum/callback/telegraph_do_after_callback = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(dynamic_ai_holder_telegraph_checks))
	start_telegraph(delay, level, no_move, no_act)
	return do_after(
		src,
		delay,
		target,
		(no_move? NONE : DO_AFTER_IGNORE_MOVEMENT) | (no_act? NONE : DO_AFTER_IGNORE_ACTIVE_ITEM),
		mobility_flags,
		max_distance,
		data = list(telegraphing_id, src),
	)

/proc/dynamic_ai_holder_telegraph_checks(list/arglist)
	// just make sure we weren't interrupted.
	var/list/data = arglist[DO_AFTER_ARG_DATA]
	var/datum/ai_holder/dynamic/holder = data[2]
	return data[1] == holder.telegraphing_id

