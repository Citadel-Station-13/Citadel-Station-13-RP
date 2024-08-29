//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Datum to track a movable entity for things like motion and other predictive qualities.
 *
 * todo: either this or spatial grid signals need to allow for signal on projectile fire / attack / etc.
 */
/datum/ai_tracking
	//* System *//
	/// last time we were requested
	var/last_requested
	/// time since last requested we should delete at
	var/gc_timeout = 30 SECONDS
	/// timerid
	var/gc_timerid

	//* Movement *//

	// last movement record
	var/movement_record_last

	// basic vel x / y immediate ; tracks within a second or two. only useful for current velocity. //

	var/imm_vel_x = 0
	var/imm_vel_y = 0

	// average vel x / y ; uses a fast rolling average. use to suppress attempts at baiting shots. //

	var/fast_vel_x = 0
	var/fast_vel_y = 0

	// movement volatility ; this is the approximate tile radius you need to aim to hit this person. this is high if they are rapidly dashing back and forth. //

	var/vel_volatile_radius = 0

/datum/ai_tracking/Destroy()
	if(gc_timerid)
		deltimer(gc_timerid)
	return ..()

/**
 * Notifies us that we've been requested.
 */
/datum/ai_tracking/proc/keep_alive()
	src.last_requested = world.time

/**
 * Tracks movement state
 *
 * * time - time since last move
 * * dir - direction of move. if it's just a Move() or otherwie standing still, this is NONE.
 */
/datum/ai_tracking/proc/track_movement(time, dir)
	movement_record_last = world.time
	var/sx
	var/sy
	switch(dir)
		if(NORTH)
			sy = 1
		if(SOUTH)
			sy = -1
		if(EAST)
			sx = 1
		if(WEST)
			sx = -1
	#warn impl

/**
 * Tells us to flush movement state.
 *
 * * Always call this before checking movement vars.
 */
/datum/ai_tracking/proc/flush_movement()
	if(movement_record_last == world.time)
		return
	track_movement(world.time - movement_record_last, NONE)

/**
 * Requests our AI tracking datum.
 *
 * * Will make one if it's not there.
 * * Will keep an existing one alive.
 */
/atom/movable/proc/request_ai_tracking()
	RETURN_TYPE(/datum/ai_tracking)
	if(src.ai_tracking)
		return src.ai_tracking
	src.ai_tracking = new
	src.ai_tracking.keep_alive()
	src.ai_tracking.gc_timerid = addtimer(CALLBACK(src, PROC_REF(expire_ai_tracking)), src.ai_tracking.gc_timeout, TIMER_LOOP, TIMER_STOPPABLE)
	return src.ai_tracking

/atom/movable/proc/expire_ai_tracking()
	if(!ai_tracking)
		return
	if(ai_tracking.last_requested + ai_tracking.gc_timeout > world.time)
		return
	QDEL_NULL(ai_tracking)
