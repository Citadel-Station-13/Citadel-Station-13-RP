//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/ai_holder/dynamic
	/// we are considered 'telegraphing' until a given world time, if set
	var/telegraphing_until
	/// telegraph level; we can be pre-empted by an inbound event of a higher tier
	var/telegraphing_level
	/// we should not be moving during this telegraph
	var/telegraphing_without_moving
	/// we should not be acting during this telegraph
	var/telegraphing_without_acting

/**
 * attempts to interrupt a telegraph if there is any
 *
 * @return TRUE if we should proceed with our action, FALSE otherwise
 */
/datum/ai_holder/dynamic/proc/interrupt_telegraph(level = AI_DYNAMIC_TELEGRAPH_INTERRUPT)
	if(isnull(telegraphing_until))
		return TRUE
	if(telegraphing_level > level)
		return FALSE
	telegraphing_until = null
	return TRUE

/**
 * starts a telegraphed action
 *
 * * will interrupt earlier telegraph if level is higher.
 */
/datum/ai_holder/dynamic/proc/telegraph(delay, level, no_move, no_act)
	if(telegraphing_until && telegraphing_level <= level)
		return FALSE
	if(!delay && !telegraphing_until)
		return TRUE
	cancel_navigation()
	telegraphing_until = world.time + delay
	telegraphing_level = level
	telegraphing_without_acting = no_act
	telegraphing_without_moving = no_move
	return TRUE
