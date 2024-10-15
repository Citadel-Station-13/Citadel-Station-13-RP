/**
 * Turret AI
 *
 * todo: firing cycle should not be handled by movement ticker, it should be handled by action scheduler.
 *
 * * Most config vars are intentionally on /turret. This is to make VV easier.
 * * In the future, we probably need an introspection panel so they can be moved here instead.
 */
/datum/ai_holder/turret
	agent_type = /obj/machinery/porta_turret

	/// delay between full pulses when already engaged
	var/combat_retarget_pulse_time = 5 SECONDS
	/// delay between full pulses when active
	var/active_retarget_pulse_time = 1 SECONDS
	/// delay between full pulses when inactive
	var/idle_retarget_pulse_time = 10 SECONDS

	/// are we in combat?
	var/in_combat = FALSE
	/// are we awake?
	var/awake = FALSE
	/// become active when mobs get within this range
	var/wake_range = 7 * 3

	/// forcefully target this target on next shot (retaliation)
	var/tmp/retaliation_target
	/// a list of targets we're currently engaging
	var/tmp/list/engaging_targets

/datum/ai_holder/turret/on_enable()
	..()
	in_combat = FALSE
	awake = FALSE
	set_ticking(idle_retarget_pulse_time)

/datum/ai_holder/turret/tick(cycles)
	var/obj/machinery/porta_turret/turret = agent
	// check if we should do anything
	if(turret.disabled || !turret.enabled)
		idle()
		return
	// first, evaluate
	var/found_in_wake_range = continuous_evaluation()
	// then,
	if(length(engaging_targets))
		// go into combat
		engage()
	else if(found_in_wake_range)
		// go into active
		wake(TRUE)
	else
		// go into idle
		idle()

/datum/ai_holder/turret/move(cycles)
	var/obj/machinery/porta_turret/turret = agent
	var/time_left = turret.get_remaining_cooldown()
	if(time_left > 0)
		return time_left
	if(turret.raising)
		return 0.5 SECONDS // wait 5 deciseconds to retry; we do not have enough granular control over popup/popdown so we just spinlock on it
	else if(!turret.raised)
		INVOKE_ASYNC(turret, TYPE_PROC_REF(/obj/machinery/porta_turret, popUp))
		return 0.5 SECONDS // ditto

	var/atom/to_shoot_at
	var/angle

	// first, prioritize retaliation target
	if(retaliation_target)
		if(valid_target(retaliation_target))
			angle = evaluate_angle_for_target(retaliation_target)
			if(!isnull(angle))
				to_shoot_at = retaliation_target
		// only retaliate once
		retaliation_target = null
	// then, if none, scan for targets to engage
	// todo: target randomization
	var/pos
	for(pos in 1 to length(engaging_targets))
		var/atom/target = engaging_targets[pos]
		if(!valid_target(target))
			continue
		if(get_dist(turret, target) > turret.disengagement_range)
			// notice how we only check this if not retaliating; this is intentional.
			continue
		angle = evaluate_angle_for_target(target)
		if(!isnull(angle))
			// acquired firing trajectory
			to_shoot_at = target
			break
	engaging_targets.Cut(1, pos)

	if(!to_shoot_at)
		// nothing to shoot at, stop
		wake(TRUE)
		return 0

	// firing cycle
	turret.timeout = max(10, turret.timeout)
	turret.try_fire_at(to_shoot_at, angle)
	// end

	return max(world.tick_lag, turret.get_remaining_cooldown())

/**
 * Get angle to hit target
 *
 * @return null if we cannot hit target, angle in deg clockwise from north if we can
 */
/datum/ai_holder/turret/proc/evaluate_angle_for_target(atom/target)
	var/obj/machinery/porta_turret/turret = agent

	var/dtx = target.x - turret.x
	var/dty = target.y - turret.y
	var/center_mass_angle = arctan(dty, dtx)
	// are we hitting center mass?
	. = trace_trajectory(target, center_mass_angle) ? center_mass_angle : null
	if(!isnull(.))
		return
	// if not, can we target sides of tile?
	if(turret.fire_curve_shots)
		// todo: projectile traces are expensive and complex. can we do better?
		// todo: this doesn't support non-32x32 bounding box projectiles
		// todo: this should be a generic helper for mob AI usage
		var/cw_angle
		var/ccw_angle
		// this aims for second pixel to allow for minute errors to not impact targeting.
		switch(get_dir(turret, target))
			if(NORTHWEST)
				cw_angle = arctan(dty + ((WORLD_ICON_SIZE * 0.5 - 2) / WORLD_ICON_SIZE), dtx + ((WORLD_ICON_SIZE * 0.5 - 2) / WORLD_ICON_SIZE))
				ccw_angle = arctan(dty - ((WORLD_ICON_SIZE * 0.5 - 2) / WORLD_ICON_SIZE), dtx - ((WORLD_ICON_SIZE * 0.5 - 2) / WORLD_ICON_SIZE))
			if(NORTHEAST)
				cw_angle = arctan(dty - ((WORLD_ICON_SIZE * 0.5 - 2) / WORLD_ICON_SIZE), dtx + ((WORLD_ICON_SIZE * 0.5 - 2) / WORLD_ICON_SIZE))
				ccw_angle = arctan(dty + ((WORLD_ICON_SIZE * 0.5 - 2) / WORLD_ICON_SIZE), dtx - ((WORLD_ICON_SIZE * 0.5 - 2) / WORLD_ICON_SIZE))
			if(SOUTHWEST)
				cw_angle = arctan(dty + ((WORLD_ICON_SIZE * 0.5 - 2) / WORLD_ICON_SIZE), dtx - ((WORLD_ICON_SIZE * 0.5 - 2) / WORLD_ICON_SIZE))
				ccw_angle = arctan(dty - ((WORLD_ICON_SIZE * 0.5 - 2) / WORLD_ICON_SIZE), dtx + ((WORLD_ICON_SIZE * 0.5 - 2) / WORLD_ICON_SIZE))
			if(SOUTHEAST)
				cw_angle = arctan(dty - ((WORLD_ICON_SIZE * 0.5 - 2) / WORLD_ICON_SIZE), dtx - ((WORLD_ICON_SIZE * 0.5 - 2) / WORLD_ICON_SIZE))
				ccw_angle = arctan(dty + ((WORLD_ICON_SIZE * 0.5 - 2) / WORLD_ICON_SIZE), dtx + ((WORLD_ICON_SIZE * 0.5 - 2) / WORLD_ICON_SIZE))
			// only diagonal angles are valid; we are not going to hit a straight line target if center mass didn't work

		if(cw_angle) // if any was detected
			. = trace_trajectory(target, cw_angle) ? cw_angle : null
			if(!isnull(.))
				return
			. = trace_trajectory(target, ccw_angle) ? ccw_angle : null
			if(!isnull(.))
				return

/**
 * Checks a trajectory.
 *
 * @params
 * * target - what we're trying to hit
 * * angle - angle to fire in
 *
 * @return if we can hit it TRUE / FALSe
 */
/datum/ai_holder/turret/proc/trace_trajectory(atom/target, angle)
	var/obj/projectile/trace/trace = new(agent.loc)
	trace.only_opacity = TRUE
	if(!trace.prepare_trace(target))
		return FALSE
	trace.fire(angle)
	return trace.could_hit_target

/**
 * Set us to in combat
 */
/datum/ai_holder/turret/proc/engage()
	if(disabled)
		return
	var/obj/machinery/porta_turret/turret = agent
	// reset timeout
	turret.timeout = 10
	// reassert ticking
	if(ticking != combat_retarget_pulse_time)
		set_ticking(combat_retarget_pulse_time)
	// make sure we're firing (movement rebuilds aren't consistent)
	// todo: this is why we shouldn't use movement for this..
	if(!movement_ticking)
		start_moving(turret.get_remaining_cooldown())
	if(in_combat)
		return
	in_combat = TRUE
	awake = TRUE
	if(!turret.raised)
		INVOKE_ASYNC(turret, TYPE_PROC_REF(/obj/machinery/porta_turret, popUp))

/**
 * Set us to awake
 */
/datum/ai_holder/turret/proc/wake(can_stop_combat)
	if(disabled)
		return
	if(in_combat && !can_stop_combat)
		return
	in_combat = FALSE
	awake = TRUE
	set_ticking(active_retarget_pulse_time)
	stop_moving()

/**
 * Set us to sleeping
 */
/datum/ai_holder/turret/proc/idle()
	if(disabled)
		return
	in_combat = FALSE
	awake = FALSE
	set_ticking(idle_retarget_pulse_time)

/**
 * Is something a valid target?
 *
 * * Please make this cheap.
 * * Do not put disengagement behavior in here.
 *
 * todo: yank z check out of here
 *
 * @return truthy value
 */
/datum/ai_holder/turret/proc/valid_target(atom/target)
	if(!ismovable(target))
		return FALSE
	if(agent.z != target.z || !target.z)
		return FALSE
	var/atom/movable/AM = target
	return AM.get_mob()

/**
 * Retaliates against a target
 */
/datum/ai_holder/turret/proc/retaliate(atom/target)
	if(!valid_target(target))
		return
	retaliation_target = target
	LAZYDISTINCTADD(engaging_targets, target)
	engage()

/**
 * Gets a list of targets to evaluate
 *
 * @params
 * * inject_into - out list
 *
 * @return atoms within **wake** range
 */
/datum/ai_holder/turret/proc/acquire_targets(list/inject_into)
	var/list/atom/filtering = \
		SSspatial_grids.living.range_query(agent, wake_range) + \
		SSspatial_grids.vehicles.range_query(agent, wake_range)
	for(var/atom/A as anything in filtering)
		if(!valid_target(A))
			continue
		inject_into += A
		++.

/**
 * Returns a list of prioritized (index 1 = most important) targets
 *
 * * Optimized for speed, not for accuracy.
 *
 * @return remain active TRUE / FALSE
 */
/datum/ai_holder/turret/proc/continuous_evaluation()
	var/obj/machinery/porta_turret/turret = agent

	var/list/atom/to_evaluate = list()
	var/found_in_wake_range = acquire_targets(to_evaluate)

	var/list/atom/head = list()
	var/list/atom/tail = list()

	for(var/atom/evaluating as anything in to_evaluate)
		if(evaluating in engaging_targets)
			if(get_dist(evaluating, turret) > turret.disengagement_range)
				continue
		else
			if(get_dist(evaluating, turret) > turret.engagement_range)
				continue
		if(isnull(evaluate_angle_for_target(evaluating)))
			continue
		switch(turret.assess_living(evaluating))
			if(TURRET_PRIORITY_TARGET)
				head += evaluating
			if(TURRET_SECONDARY_TARGET)
				tail += evaluating
			if(TURRET_NOT_TARGET)
				continue

	engaging_targets = head + tail
	return found_in_wake_range
