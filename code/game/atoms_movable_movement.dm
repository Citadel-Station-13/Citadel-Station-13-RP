/**
  * Hook for running code when a dir change occurs
  *
  * Not recommended to use, listen for the [COMSIG_ATOM_DIR_CHANGE] signal instead (sent by this proc)
  */
/atom/proc/setDir(newdir)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_DIR_CHANGE, dir, newdir)
	dir = newdir

////////////////////////////////////////
// Here's where we rewrite how byond handles movement except slightly different
// To be removed on step_ conversion
// All this work to prevent a second bump
/atom/movable/Move(atom/newloc, direct=0)
	. = FALSE
	if(!newloc || newloc == loc)
		return

	if(!direct)
		direct = get_dir(src, newloc)
	setDir(direct)

	if(!loc.Exit(src, newloc))
		return

	if(!newloc.Enter(src, src.loc))
		return

	if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, newloc) & COMPONENT_MOVABLE_BLOCK_PRE_MOVE)
		return

	// Past this is the point of no return
	if(length(locs) <= 1)	// We're not a multi-tile object.
		var/atom/oldloc = loc
		var/area/oldarea = get_area(oldloc)
		var/area/newarea = get_area(newloc)
		loc = newloc
		. = TRUE
		oldloc.Exited(src, newloc)
		if(oldarea != newarea)
			oldarea.Exited(src, newloc)

		for(var/i in oldloc)
			if(i == src) // Multi tile objects
				continue
			var/atom/movable/thing = i
			thing.Uncrossed(src)

		newloc.Entered(src, oldloc)
		if(oldarea != newarea)
			newarea.Entered(src, oldloc)

		for(var/i in loc)
			if(i == src) // Multi tile objects
				continue
			var/atom/movable/thing = i
			thing.Crossed(src)

	else if(newloc)	// We're a multi-tile object.
		if(!check_multi_tile_move_density_dir(direct, locs))	// We're big, and we can't move that way.
			return
		. = doMove(newloc)

//
////////////////////////////////////////

/atom/movable/Move(atom/newloc, direct = 0)
	if(!loc || !newloc)
		return FALSE
	var/atom/oldloc = loc

	if(loc != newloc)
		if(!direct)
			direct = get_dir(oldloc, newloc)
		if (!(direct & (direct - 1))) //Cardinal move
			. = ..()
		else //Diagonal move, split it into cardinal moves
			moving_diagonally = FIRST_DIAG_STEP
			var/first_step_dir
			// The `&& moving_diagonally` checks are so that a forceMove taking
			// place due to a Crossed, Bumped, etc. call will interrupt
			// the second half of the diagonal movement, or the second attempt
			// at a first half if step() fails because we hit something.
			if (direct & NORTH)
				if (direct & EAST)
					if (step(src, NORTH) && moving_diagonally)
						first_step_dir = NORTH
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, EAST)
					else if (moving_diagonally && step(src, EAST))
						first_step_dir = EAST
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, NORTH)
				else if (direct & WEST)
					if (step(src, NORTH) && moving_diagonally)
						first_step_dir = NORTH
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, WEST)
					else if (moving_diagonally && step(src, WEST))
						first_step_dir = WEST
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, NORTH)
			else if (direct & SOUTH)
				if (direct & EAST)
					if (step(src, SOUTH) && moving_diagonally)
						first_step_dir = SOUTH
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, EAST)
					else if (moving_diagonally && step(src, EAST))
						first_step_dir = EAST
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, SOUTH)
				else if (direct & WEST)
					if (step(src, SOUTH) && moving_diagonally)
						first_step_dir = SOUTH
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, WEST)
					else if (moving_diagonally && step(src, WEST))
						first_step_dir = WEST
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, SOUTH)
			if(moving_diagonally == SECOND_DIAG_STEP)
				if(!.)
					setDir(first_step_dir)
				//else if (!inertia_moving)
				//	inertia_next_move = world.time + inertia_move_delay
				//	newtonian_move(direct)
			moving_diagonally = 0
			return

	if(!loc || (loc == oldloc && oldloc != newloc))
		last_move = 0
		return

	if(.)
		Moved(oldloc, direct)

	//Polaris stuff
	move_speed = world.time - l_move_time
	l_move_time = world.time
	m_flag = 1
	//End

	last_move = direct
	setDir(direct)
	if(. && has_buckled_mobs() && !handle_buckled_mob_movement(loc,direct)) //movement failed due to buckled mob(s)
		return FALSE
	//VOREStation Add
	else if(. && riding_datum)
		riding_datum.handle_vehicle_layer()
		riding_datum.handle_vehicle_offsets()
	//VOREStation Add End

//Called after a successful Move(). By this point, we've already moved
/atom/movable/proc/Moved(atom/OldLoc, Dir, Forced = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, OldLoc, Dir, Forced)
/*
	if (!inertia_moving)
		inertia_next_move = world.time + inertia_move_delay
		newtonian_move(Dir)
	if (length(client_mobs_in_contents))
		update_parallax_contents()
*/

	return TRUE

// Make sure you know what you're doing if you call this, this is intended to only be called by byond directly.
// You probably want CanPass()
/atom/movable/Cross(atom/movable/AM)
	. = TRUE
	SEND_SIGNAL(src, COMSIG_MOVABLE_CROSS, AM)
	return CanPass(AM, AM.loc, TRUE)

//oldloc = old location on atom, inserted when forceMove is called and ONLY when forceMove is called!
/atom/movable/Crossed(atom/movable/AM, oldloc)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	SEND_SIGNAL(src, COMSIG_MOVABLE_CROSSED, AM)

/atom/movable/Uncross(atom/movable/AM, atom/newloc)
	. = ..()
	if(SEND_SIGNAL(src, COMSIG_MOVABLE_UNCROSS, AM) & COMPONENT_MOVABLE_BLOCK_UNCROSS)
		return FALSE
	if(isturf(newloc) && !CheckExit(AM, newloc))
		return FALSE

/atom/movable/Uncrossed(atom/movable/AM)
	SEND_SIGNAL(src, COMSIG_MOVABLE_UNCROSSED, AM)

/atom/movable/Bump(atom/A)
	if(!A)
		CRASH("Bump was called with no argument.")
	SEND_SIGNAL(src, COMSIG_MOVABLE_BUMP, A)
	. = ..()
	// vore code
	if(throwing)
		throw_impact(A)
		throwing = 0
		if(QDELETED(A))
			return
	A.last_bumped = world.time
	// vore code end
/*
	if(!QDELETED(throwing))
		throwing.hit_atom(A)
		. = TRUE
		if(QDELETED(A))
			return
*/
	A.Bumped(src)

/**
  * forceMove but it brings along pulling/buckled stuff
  * recurse_levels determines how many levels it recurses this call. Don't set it too high or else someone's going to transit 20 conga liners in a single move.
  * Probably needs a better way of handling this in the future.
  */

/atom/movable/proc/locationTransitForceMove(atom/destination, recurse_levels = 0)
	var/list/mob/oldbuckled = buckled_mobs?.Copy()
	doLocationTransitForceMove(destination)
	if(length(oldbuckled))
		for(var/mob/M in oldbuckled)
			if(recurse_levels)
				M.locationTransitForceMove(destination, recurse_levels - 1)
			else
				M.doLocationTransitForceMove(destination)
			buckle_mob(M, force = TRUE)

// until movement rework
/mob/locationTransitForceMove(atom/destination, recurse_levels = 0)
	var/atom/movable/oldpulling = pulling
	. = ..()
	if(oldpulling)
		if(recurse_levels)
			oldpulling.locationTransitForceMove(destination, recurse_levels - 1)
		else
			oldpulling.doLocationTransitForceMove(destination)
		start_pulling(oldpulling)

/**
  * Gets the atoms that we'd pull along with a locationTransitForceMove
  */
/atom/movable/proc/getLocationTransitForceMoveTargets(atom/destination, recurse_levels = 0)
	. = list(src)
	if(buckled_mobs)
		for(var/mob/M in buckled_mobs)
			if(recurse_levels)
				. |= M.getLocationTransitForceMoveTargets(destination, recurse_levels - 1)
			else
				. |= M

// until movement rework
/mob/getLocationTransitForceMoveTargets(atom/destination, recurse_levels = 0)
	. = ..()
	if(pulling)
		if(recurse_levels)
			. |= pulling.getLocationTransitForceMoveTargets(destination, recurse_levels - 1)
		else
			. |= pulling

/**
  * Wrapper for forceMove when we're called by a recursing locationTransitForceMove().
  */
/atom/movable/proc/doLocationTransitForceMove(atom/destination)
	forceMove(destination)

/atom/movable/proc/forceMove(atom/destination)
	. = FALSE
	if(destination)
		. = doMove(destination)
	else
		CRASH("No valid destination passed into forceMove")

/atom/movable/proc/moveToNullspace()
	return doMove(null)

/atom/movable/proc/doMove(atom/destination)
	. = FALSE
	if(destination)
		if(pulledby)
			pulledby.stop_pulling()
		var/atom/oldloc = loc
		var/same_loc = oldloc == destination
		var/area/old_area = get_area(oldloc)
		var/area/destarea = get_area(destination)

		loc = destination
		moving_diagonally = 0

		if(!same_loc)
			if(oldloc)
				oldloc.Exited(src, destination)
				if(old_area && old_area != destarea)
					old_area.Exited(src, destination)
			for(var/atom/movable/AM in oldloc)
				AM.Uncrossed(src)
			var/turf/oldturf = get_turf(oldloc)
			var/turf/destturf = get_turf(destination)
			var/old_z = (oldturf ? oldturf.z : null)
			var/dest_z = (destturf ? destturf.z : null)
			if (old_z != dest_z)
				onTransitZ(old_z, dest_z)
			destination.Entered(src, oldloc)
			if(destarea && old_area != destarea)
				destarea.Entered(src, oldloc)

			for(var/atom/movable/AM in destination)
				if(AM == src)
					continue
				AM.Crossed(src, oldloc)

		Moved(oldloc, NONE, TRUE)
		. = TRUE

	//If no destination, move the atom into nullspace (don't do this unless you know what you're doing)
	else
		. = TRUE
		if (loc)
			var/atom/oldloc = loc
			var/area/old_area = get_area(oldloc)
			oldloc.Exited(src, null)
			if(old_area)
				old_area.Exited(src, null)
		loc = null

/atom/movable/proc/onTransitZ(old_z,new_z)
	SEND_SIGNAL(src, COMSIG_MOVABLE_Z_CHANGED, old_z, new_z)
	for(var/item in src) // Notify contents of Z-transition. This can be overridden IF we know the items contents do not care.
		var/atom/movable/AM = item
		AM.onTransitZ(old_z,new_z)

/**
  * Sets our glide size
  */
/atom/movable/proc/set_glide_size(new_glide_size)
	SEND_SIGNAL(src, COMSIG_MOVABLE_CHANGE_GLIDE_SIZE, new_glide_size, glide_size)
	glide_size = new_glide_size

/**
  * Sets our glide size back to our standard glide size.
  */

/atom/movable/proc/reset_glide_size()
	set_glide_size(default_glide_size)
