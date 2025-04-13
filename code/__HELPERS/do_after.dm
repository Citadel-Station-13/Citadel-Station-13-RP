// TODO: Refactor do_mob, add actionspeed support to do_mob, do_after, do_self.
// (or don't for actionspeed, why are we checking it in the proc anyways...)

/proc/do_mob(mob/user , mob/target, time = 30, target_zone = 0, uninterruptible = FALSE, progress = TRUE, ignore_movement = FALSE)
	if(!user || !target)
		return 0
	var/user_loc = user.loc
	var/target_loc = target.loc

	START_INTERACTING_WITH(user, target, INTERACTING_FOR_DO_AFTER)

	var/holding = user.get_active_held_item()
	var/datum/progressbar/progbar
	if (progress)
		progbar = new(user, time, target)

	var/endtime = world.time + time
	var/starttime = world.time
	. = TRUE
	while (world.time < endtime)
		stoplag(1)
		if (progress && !QDELETED(progbar))
			progbar.update(world.time - starttime)
		if(!user || !target)
			. = FALSE
			break
		if(uninterruptible)
			continue

		if(!INTERACTING_WITH_FOR(user, target, INTERACTING_FOR_DO_AFTER))
			. = FALSE
			break

		if(!user || user.incapacitated())
			. = FALSE
			break

		if(user.loc != user_loc && !ignore_movement)
			. = FALSE
			break

		if(target.loc != target_loc && !ignore_movement)
			. = FALSE
			break

		if(user.get_active_held_item() != holding)
			. = FALSE
			break

		if(target_zone && user.zone_sel.selecting != target_zone)
			. = FALSE
			break

	if(!QDELETED(progbar))
		progbar.end_progress()

	STOP_INTERACTING_WITH(user, target, INTERACTING_FOR_DO_AFTER)

/**
 * Does an action after a delay.
 *
 * TODO: set progressbar delay to target delay or otherwise be able to reuse progressbar?
 *
 * @params
 * * user - acting mob
 * * delay - how long in deciseconds
 * * target - targeted atom, if any
 * * flags - do_after flags as specified in [code/__DEFINES/procs/do_after.dm]
 * * mobility_flags - required mobility flags
 * * max_distance - if not null, the user is required to be get_dist() <= max_distance from target.
 * * additional_checks - a callback that allows for custom checks. this is invoked with our args directly, allowing us to modify delay.
 * * progress_anchor - override progressbar anchor location
 * * progress_instance - override progressbar instance; this progressbar instance will be **deleted** when we are finished,
 *                       and should have a goal number equal to the delay.
 */
/proc/do_after(mob/user, delay, atom/target, flags, mobility_flags = MOBILITY_CAN_USE, max_distance, datum/callback/additional_checks, atom/progress_anchor, datum/progressbar/progress_instance)
	if(isnull(user) || QDELETED(user))
		progress_instance?.end_progress()
		return FALSE
	if(!delay)
		progress_instance?.end_progress()
		return \
		(isnull(additional_checks) || additional_checks.Invoke(args)) && \
		(isnull(max_distance) || get_dist(user, target) <= max_distance) && \
		CHECK_ALL_MOBILITY(user, mobility_flags)

	//* setup

	//? legacy
	if(ismecha(user.loc))
		flags |= DO_AFTER_CHECK_USER_TURF
	//? end

	var/atom/user_loc = user.loc
	var/turf/user_turf = (flags & DO_AFTER_CHECK_USER_TURF)? get_turf(user) : null
	var/atom/target_loc
	var/turf/target_turf

	if(!isnull(target))
		target_loc = target.loc
		target_turf = (flags & DO_AFTER_CHECK_TARGET_TURF)? get_turf(target) : null
		START_INTERACTING_WITH(user, target, INTERACTING_FOR_DO_AFTER)

	var/obj/item/active_held_item = user.get_active_held_item()

	var/datum/progressbar/progress = progress_instance
	var/original_delay = delay
	var/delay_factor = 1
	if(isnull(progress) && !(flags & DO_AFTER_NO_PROGRESS) && (!isnull(progress_anchor || !isnull(target))))
		progress = new(user, delay, progress_anchor || target)
	var/start_time = world.time

	//* loop

	. = TRUE
	while(world.time < (start_time + delay))
		stoplag(1)

		if (progress && !QDELETED(progress))
			progress.update((world.time - start_time) * delay_factor)

		// check if deleted
		if(QDELETED(user))
			. = FALSE
			break

		// check mobility
		if(!CHECK_ALL_MOBILITY(user, mobility_flags))
			. = FALSE
			break

		// check movement
		if(!(flags & DO_AFTER_IGNORE_USER_MOVEMENT) && (user.loc != user_loc))
			. = FALSE
			break

		if(!isnull(user_turf) && (get_turf(user) != user_turf))
			. = FALSE
			break

		// check held
		if(!(flags & DO_AFTER_IGNORE_ACTIVE_ITEM) && (active_held_item != user.get_active_held_item()))
			. = FALSE
			break

		// target checks
		if(!isnull(target))

			// check if deleted
			if(QDELETED(target))
				. = FALSE
				break

			// check if interrupted
			if(!INTERACTING_WITH_FOR(user, target, INTERACTING_FOR_DO_AFTER))
				. = FALSE
				break

			// check movement
			if(!(flags & DO_AFTER_IGNORE_USER_MOVEMENT) && (target.loc != target_loc))
				. = FALSE
				break
			if(!isnull(target_turf) && (get_turf(target) != target_turf))
				. = FALSE
				break

			// check max distance - does NOT check z as of right now!
			if(!isnull(max_distance) && get_dist(user, target) > max_distance)
				. = FALSE
				break

		if(!isnull(additional_checks))
			if(!additional_checks.Invoke(args))
				. = FALSE
				break
			// update delay factor incase they changed
			delay_factor = original_delay / delay

	//* end
	if(!QDELETED(progress))
		progress.end_progress()

	if(!isnull(target))
		STOP_INTERACTING_WITH(user, target, INTERACTING_FOR_DO_AFTER)

/**
 * Does an action to ourselves after a delay.
 *
 * @params
 * * user - acting mob
 * * delay - how long in deciseconds
 * * flags - do_after flags as specified in [code/__DEFINES/procs/do_after.dm]
 * * mobility_flags - required mobility flags
 * * additional_checks - a callback that allows for custom checks. this is invoked with our args directly, allowing us to modify delay.
 */
/proc/do_self(mob/user, delay, flags, mobility_flags = MOBILITY_CAN_USE, datum/callback/additional_checks)
	return do_after(
		user,
		delay,
		flags = flags,
		mobility_flags = mobility_flags,
		additional_checks = additional_checks,
	)
