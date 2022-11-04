/**
  * Hook for running code when a dir change occurs
  *
  * Not recommended to use, listen for the [COMSIG_ATOM_DIR_CHANGE] signal instead (sent by this proc)
  */
/atom/proc/setDir(newdir)
	if(dir == newdir)
		return FALSE
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_DIR_CHANGE, dir, newdir)
	dir = newdir
	return TRUE

////////////////////////////////////////
// Here's where we rewrite how byond handles movement except slightly different
// To be removed on step_ conversion
// All this work to prevent a second bump
/atom/movable/Move(atom/newloc, direct = NONE)
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

/atom/movable/Move(atom/newloc, direct, glide_size_override)
	var/atom/movable/pullee = pulling
	var/turf/T = loc
	if(!moving_from_pull)
		check_pulling()
	if(!loc || !newloc)
		return FALSE
	var/atom/oldloc = loc
	//Early override for some cases like diagonal movement
	if(glide_size_override)
		set_glide_size(glide_size_override, FALSE)

	if(loc != newloc)
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
				else if (!inertia_moving)
					inertia_next_move = world.time + inertia_move_delay
					newtonian_move(direct)
			moving_diagonally = 0
			return
	else		// trying to move to the same place
		if(direct)
			last_move_dir = direct
			setDir(direct)
		return TRUE		// not moving is technically success

	if(!loc || (loc == oldloc && oldloc != newloc))
		last_move_dir = NONE
		return

	if(. && has_buckled_mobs() && !handle_buckled_mob_movement(loc, direct, glide_size_override)) //movement failed due to buckled mob(s)
		return FALSE

	if(.)
		Moved(oldloc, direct)

	if(. && pulling && pulling == pullee && pulling != moving_from_pull) //we were pulling a thing and didn't lose it during our move.
		if(pulling.anchored)
			stop_pulling()
		else
			var/pull_dir = get_dir(src, pulling)
			//puller and pullee more than one tile away or in diagonal position
			if(get_dist(src, pulling) > 1 || (moving_diagonally != SECOND_DIAG_STEP && ((pull_dir - 1) & pull_dir)))
				pulling.moving_from_pull = src
				var/success = pulling.Move(T, get_dir(pulling, T), glide_size) //the pullee tries to reach our previous position
				pulling.moving_from_pull = null
				if(success)
					// hook for baystation stuff
					on_move_pulled(pulling)
					// end
			check_pulling()

	if(direct)
		last_move_dir = direct
		setDir(direct)

	//glide_size strangely enough can change mid movement animation and update correctly while the animation is playing
	//This means that if you don't override it late like this, it will just be set back by the movement update that's called when you move turfs.
	if(glide_size_override)
		set_glide_size(glide_size_override, FALSE)

	move_speed = world.time - l_move_time
	l_move_time = world.time

//! WARNING WARNING THIS IS SHITCODE
/atom/movable/proc/handle_buckled_mob_movement(newloc, direct, glide_size_override, forcemoving)
	for(var/mob/M as anything in buckled_mobs)
		if(!M.Move(newloc, direct, glide_size_override))
			if(forcemoving)
				unbuckle_mob(M, BUCKLE_OP_FORCE | BUCKLE_OP_SILENT)
				continue
			else
				forceMove(M.loc)
			last_move_dir = M.last_move_dir
			inertia_dir = last_move_dir
			for(var/mob/resetting as anything in buckled_mobs)
				if(resetting.loc != loc)
					resetting.forceMove(loc)
			return FALSE
		else
			M.setDir(dir)
	return TRUE

/// Called after a successful Move(). By this point, we've already moved
/atom/movable/proc/Moved(atom/OldLoc, Dir, Forced = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, OldLoc, Dir, Forced)
	if (!inertia_moving)
		inertia_next_move = world.time + inertia_move_delay
		newtonian_move(Dir)
/*
	if (length(client_mobs_in_contents))
		update_parallax_contents()
*/

	return TRUE

/// Make sure you know what you're doing if you call this, this is intended to only be called by byond directly.
/// You probably want CanPass()
/atom/movable/Cross(atom/movable/AM)
	. = TRUE
	SEND_SIGNAL(src, COMSIG_MOVABLE_CROSS, AM)
	return CanPass(AM, src, TRUE)

//oldloc = old location on atom, inserted when forceMove is called and ONLY when forceMove is called!
/atom/movable/Crossed(atom/movable/AM, oldloc)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	SEND_SIGNAL(src, COMSIG_MOVABLE_CROSSED, AM)
	throwing?.crossed_by(AM)

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

	if(throwing)
		throwing.bump_into(A)
		if(QDELETED(src) || QDELETED(A))
			return TRUE

	A.last_bumped = world.time
	A.Bumped(src)

/**
  * forceMove but it brings along pulling/buckled stuff
  * recurse_levels determines how many levels it recurses this call. Don't set it too high or else someone's going to transit 20 conga liners in a single move.
  * Probably needs a better way of handling this in the future.
  */
/atom/movable/proc/locationTransitForceMove(atom/destination, recurse_levels = 0, allow_buckled = TRUE, allow_pulled = TRUE, allow_grabbed = GRAB_PASSIVE, list/recursed = list())
	// we need the recursion guard for loop situations.
	// todo: rework everything about this proc omg
	if(recursed[src])
		return
	recursed[src] = TRUE

	var/atom/movable/oldpulling
	if(pulling)
		oldpulling = pulling
		stop_pulling()

	var/list/mob/oldbuckled
	if(buckled_mobs)
		oldbuckled = buckled_mobs.Copy()

	// move
	. = doLocationTransitForceMove(destination)
	if(!.)
		return

	if(length(oldbuckled))
		for(var/mob/M in oldbuckled)
			if(recurse_levels)
				M.locationTransitForceMove(destination, recurse_levels - 1)
			else
				M.doLocationTransitForceMove(destination)
			if(!(M.buckled == src))
				buckle_mob(M, BUCKLE_OP_FORCE | BUCKLE_OP_IGNORE_LOC | BUCKLE_OP_SILENT, oldbuckled[M])

	if(oldpulling)
		if(recurse_levels)
			oldpulling.locationTransitForceMove(destination, recurse_levels - 1)
		else
			oldpulling.doLocationTransitForceMove(destination)
		start_pulling(oldpulling, suppress_message = TRUE)

/mob/locationTransitForceMove(atom/destination, recurse_levels = 0, allow_buckled = TRUE, allow_pulled = TRUE, allow_grabbed = GRAB_PASSIVE, list/recursed = list())
	var/list/old_grabbed
	if(allow_grabbed)
		old_grabbed = list()
		for(var/mob/M in grabbing())
			if(check_grab(M) < allow_grabbed)
				continue
			old_grabbed += M
	. = ..()
	if(!.)
		return
	for(var/mob/M in old_grabbed)
		M.forceMove(loc)

/**
  * Gets the atoms that we'd pull along with a locationTransitForceMove
  */
/atom/movable/proc/getLocationTransitForceMoveTargets(atom/destination, recurse_levels = 0, allow_buckled = TRUE, allow_pulled = TRUE, allow_grabbed = GRAB_PASSIVE, list/recursed = list())
	if(recursed[src])
		return list()
	recursed[src] = TRUE
	. = list(src)
	if(allow_pulled)
		. |= recurse_levels? pulling.getLocationTransitForceMoveTargets(destination, recurse_levels - 1, allow_buckled, allow_pulled, allow_grabbed, recursed) : pulling
	if(allow_buckled && buckled_mobs)
		for(var/mob/M in buckled_mobs)
			. |= recurse_levels? M.getLocationTransitForceMoveTargets(destination, recurse_levels - 1, allow_buckled, allow_pulled, allow_grabbed, recursed) : M

// until movement rework
/mob/getLocationTransitForceMoveTargets(atom/destination, recurse_levels = 0, allow_buckled = TRUE, allow_pulled = TRUE, allow_grabbed = GRAB_PASSIVE)
	. = ..()
	if(allow_grabbed)
		var/list/grabbing = grabbing()
		for(var/mob/M in grabbing)
			if(check_grab(M) < allow_grabbed)
				continue
			. |= recurse_levels? M.getLocationTransitForceMoveTargets(destination, recurse_levels - 1, allow_buckled, allow_pulled, allow_grabbed) : M

/**
  * Wrapper for forceMove when we're called by a recursing locationTransitForceMove().
  */
/atom/movable/proc/doLocationTransitForceMove(atom/destination)
	. = TRUE
	forceMove(destination)

/atom/movable/proc/forceMove(atom/destination)
	. = FALSE
	pulledby?.stop_pulling()
	if(destination)
		. = doMove(destination)
	else
		CRASH("No valid destination passed into forceMove")

/atom/movable/proc/moveToNullspace()
	return doMove(null)

/atom/movable/proc/doMove(atom/destination)
	. = FALSE
	if(destination)
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
		if(pulling)
			check_pulling()
		if(pulledby)
			pulledby.check_pulling()
		if(buckled_mobs)
			handle_buckled_mob_movement(destination, dir, glide_size, TRUE)
		. = TRUE

	//If no destination, move the atom into nullspace (don't do this unless you know what you're doing)
	else
		. = TRUE
		if(buckled_mobs)
			unbuckle_all_mobs(BUCKLE_OP_FORCE)
		pulledby?.stop_pulling()
		if(pulling)
			stop_pulling()
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

/atom/movable/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(mover in buckled_mobs)
		return TRUE

/// Returns true or false to allow src to move through the blocker, mover has final say
/atom/movable/proc/CanPassThrough(atom/blocker, turf/target, blocker_opinion)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_BE_PURE(TRUE)
	return blocker_opinion

/**
  * Called whenever an object moves and by mobs when they attempt to move themselves through space
  * And when an object or action applies a force on src, see [newtonian_move][/atom/movable/proc/newtonian_move]
  *
  * Return 0 to have src start/keep drifting in a no-grav area and 1 to stop/not start drifting
  *
  * Mobs should return 1 if they should be able to move of their own volition, see [/client/Move]
  *
  * Arguments:
  * * movement_dir - 0 when stopping or any dir when trying to move
  */
/atom/movable/proc/Process_Spacemove(movement_dir = NONE)
	if(has_gravity(src))
		return TRUE

	if(pulledby)
		return TRUE

	if(throwing)
		return TRUE

	if(!isturf(loc))
		return TRUE

	if(locate(/obj/structure/lattice) in range(1, get_turf(src))) //Not realistic but makes pushing things in space easier
		return TRUE

	return FALSE

/// Only moves the object if it's under no gravity
/atom/movable/proc/newtonian_move(direction)
	if(!loc || Process_Spacemove(NONE))
		inertia_dir = NONE
		return FALSE

	inertia_dir = direction
	if(!direction)
		return TRUE
	inertia_last_loc = loc
	SSspacedrift.processing[src] = src
	return TRUE

/**
  * Sets our glide size
  */
/atom/movable/proc/set_glide_size(new_glide_size, recursive = TRUE)
	SEND_SIGNAL(src, COMSIG_MOVABLE_UPDATE_GLIDE_SIZE, new_glide_size, glide_size)
	glide_size = new_glide_size

	if(!recursive)
		return

	for(var/m in buckled_mobs)
		var/mob/buckled_mob = m
		buckled_mob.set_glide_size(glide_size)
		recursive_glidesize_update()

/**
  * Sets our glide size back to our standard glide size.
  */

/atom/movable/proc/reset_glide_size()
	set_glide_size(isnull(default_glide_size)? GLOB.default_glide_size : default_glide_size)

///Sets the anchored var and returns if it was sucessfully changed or not.
/atom/movable/proc/set_anchored(anchorvalue)
	SHOULD_CALL_PARENT(TRUE)
	if(anchored == anchorvalue)
		return
	. = anchored
	anchored = anchorvalue
	SEND_SIGNAL(src, COMSIG_MOVABLE_SET_ANCHORED, anchorvalue)

//? todo: this system is shit
/**
 * return true to let something push through us
 */
/atom/movable/proc/force_pushed(atom/movable/pusher, force = MOVE_FORCE_DEFAULT, direction)
	return FALSE

/**
 * return true to let something crush through us
 */
/atom/movable/proc/move_crushed(atom/movable/pusher, force = MOVE_FORCE_DEFAULT, direction)
	return FALSE

/atom/movable/proc/force_push(atom/movable/AM, force = move_force, direction, silent)
	. = AM.force_pushed(src, force, direction)
	if(!silent && .)
		visible_message("<span class='warning'>[src] forcefully pushes against [AM]!</span>", "<span class='warning'>You forcefully push against [AM]!</span>")

/atom/movable/proc/move_crush(atom/movable/AM, force = move_force, direction, silent)
	. = AM.move_crushed(src, force, direction)
	if(!silent && .)
		visible_message("<span class='danger'>[src] crushes past [AM]!</span>", "<span class='danger'>You crush [AM]!</span>")

/**
 * for regexing
 */
/atom/movable/proc/check_pass_flags(flags)
	return pass_flags & flags
