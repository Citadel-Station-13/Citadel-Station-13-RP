// TODO: Refactor everything, add actionspeed support.

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
		if (progress)
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
		qdel(progbar)

	STOP_INTERACTING_WITH(user, target, INTERACTING_FOR_DO_AFTER)

/proc/do_after(mob/user, delay, atom/target = null, needhand = TRUE, progress = TRUE, incapacitation_flags = INCAPACITATION_DEFAULT, ignore_movement = FALSE, max_distance = null, ignore_resist = FALSE)
	if(!user)
		return 0
	if(!delay)
		return 1 //Okay. Done.
	var/atom/target_loc = null
	if(target)
		target_loc = target.loc
		START_INTERACTING_WITH(user, target, INTERACTING_FOR_DO_AFTER)

	var/atom/original_loc = user.loc

	var/obj/mecha/M = null

	if(ismecha(user.loc))
		original_loc = get_turf(original_loc)
		M = user.loc

	var/holding = user.get_active_held_item()

	var/datum/progressbar/progbar
	if (progress)
		progbar = new(user, delay, target)

	var/endtime = world.time + delay
	var/starttime = world.time
	. = 1
	while (world.time < endtime)
		stoplag(1)
		if(progress)
			progbar.update(world.time - starttime)

		if(!user || user.incapacitated(incapacitation_flags))
			. = FALSE
			break

		if(M)
			if(user.loc != M || (M.loc != original_loc && !ignore_movement)) // Mech coooooode.
				. = FALSE
				break

		else if(user.loc != original_loc && !ignore_movement)
			. = FALSE
			break

		if(target_loc && (QDELETED(target)))
			. = FALSE
			break

		if(target && target_loc != target.loc && !ignore_movement)
			. = FALSE
			break

		if(target && !INTERACTING_WITH_FOR(user, target, INTERACTING_FOR_DO_AFTER))
			. = FALSE
			break

		if(needhand)
			if(user.get_active_held_item() != holding)
				. = FALSE
				break

		if(max_distance && target && get_dist(user, target) > max_distance)
			. = FALSE
			break

	if(!QDELETED(progbar))
		qdel(progbar)

	if(target)
		STOP_INTERACTING_WITH(user, target, INTERACTING_FOR_DO_AFTER)
