/**
 * returns the topmost atom on a turf we're in, or null
 * if a non movable is passed, itself is returned
 */
/proc/get_top_level_atom(atom/movable/AM)
	// if turf or area, return itself
	if(!istype(AM))
		return AM
	// if nullspace, return null
	if(!AM.loc)
		return
	// keep going up until we are on a turf
	while(!isturf(AM.loc))
		AM = AM.loc
	return AM

/proc/get_turf_pixel(atom/movable/AM)
	if(!istype(AM))
		return

	//! Find AM's matrix so we can use it's X/Y pixel shifts.
	var/matrix/M = matrix(AM.transform)

	var/pixel_x_offset = AM.pixel_x + M.get_x_shift()
	var/pixel_y_offset = AM.pixel_y + M.get_y_shift()

	//! Irregular objects.
	if(AM.bound_height != world.icon_size || AM.bound_width != world.icon_size)
		var/icon/AMicon = icon(AM.icon, AM.icon_state)
		pixel_x_offset += ((AMicon.Width()/world.icon_size)-1)*(world.icon_size*0.5)
		pixel_y_offset += ((AMicon.Height()/world.icon_size)-1)*(world.icon_size*0.5)
		qdel(AMicon)

	//! DY and DX.
	var/rough_x = round(round(pixel_x_offset,world.icon_size)/world.icon_size)
	var/rough_y = round(round(pixel_y_offset,world.icon_size)/world.icon_size)

	//! Find coordinates.
	//u Use AM's turfs, as it's coords are the same as AM's AND AM's coords are lost if it is inside another atom.
	var/turf/T = get_turf(AM)
	var/final_x = T.x + rough_x
	var/final_y = T.y + rough_y

	if(final_x || final_y)
		return locate(final_x, final_y, T.z)

/**
 * Walks up the loc tree until it finds a holder of the given holder_type.
 */
/proc/get_holder_of_type(atom/A, holder_type)
	if(!istype(A))
		return
	for(A, A && !istype(A, holder_type), A=A.loc);
	return A

/atom/movable/proc/throw_at_random(include_own_turf, maxrange, speed)
	var/list/turfs = trange(maxrange, src)
	if(!maxrange)
		maxrange = 1

	if(!include_own_turf)
		turfs -= get_turf(src)
	src.throw_at_old(pick(turfs), maxrange, speed, src)

/**
 * Same as do_mob except for movables and it allows both to drift and doesn't draw progressbar.
 */
/proc/do_atom(atom/movable/user , atom/movable/target, time = 30, uninterruptible = 0,datum/callback/extra_checks = null)
	if(!user || !target)
		return TRUE
	var/user_loc = user.loc

	var/drifting = FALSE
	if(!user.Process_Spacemove(0) && user.inertia_dir)
		drifting = TRUE

	var/target_drifting = FALSE
	if(!target.Process_Spacemove(0) && target.inertia_dir)
		target_drifting = TRUE

	var/target_loc = target.loc

	var/endtime = world.time+time
	. = TRUE
	while (world.time < endtime)
		stoplag(1)
		if(QDELETED(user) || QDELETED(target))
			. = 0
			break
		if(uninterruptible)
			continue

		if(drifting && !user.inertia_dir)
			drifting = FALSE
			user_loc = user.loc

		if(target_drifting && !target.inertia_dir)
			target_drifting = FALSE
			target_loc = target.loc

		if((!drifting && user.loc != user_loc) || (!target_drifting && target.loc != target_loc) || (extra_checks && !extra_checks.Invoke()))
			. = FALSE
			break
