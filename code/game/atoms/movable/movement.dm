/**
 * Internal Move() handling, called from the actual Move() implementation via override and ..()
 * This rewrites how we handle movement to avoid some BYOND-isms.
 */
/atom/movable/Move(atom/newloc, direct, step_x, step_y, glide_size_override)
	. = FALSE
	if(newloc == loc)
		return

	setDir(direct)

	var/is_multi_tile = bound_width > world.icon_size || bound_height > world.icon_size

	// send one signal for single or multi tile because we don't want to just spam signals
	if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, newloc) & COMPONENT_MOVABLE_BLOCK_PRE_MOVE)
		return

	if(is_multi_tile && isturf(loc) && isturf(newloc))
		//* multi tile handling *//
		var/list/leaving
		var/list/entering
		// this is the turf we can't directly access with either newloc or loc, for caching / speed.
		var/turf/opposite
		switch(direct)
			if(NORTH)
				opposite = locate(
					newloc.x,
					min(world.maxy, newloc.y + CEILING(bound_height / 32, 1) - 1),
					newloc.z
				)
				leaving = block(
					loc,
					locate(
						min(world.maxx, loc.x + CEILING(bound_width / 32, 1) - 1),
						loc.y,
						loc.z
					)
				)
				entering = block(
					opposite,
					locate(
						min(world.maxx, opposite.x + CEILING(bound_width / 32, 1) - 1),
						opposite.y,
						opposite.z
					)
				)
			if(SOUTH)
				opposite = locate(
					loc.x,
					min(world.maxy, loc.y + CEILING(bound_height / 32, 1) - 1),
					loc.z
				)
				leaving = block(
					opposite,
					locate(
						min(world.maxx, opposite.x + CEILING(bound_width / 32, 1) - 1),
						opposite.y,
						opposite.z
					)
				)
				entering = block(
					newloc,
					locate(
						min(world.maxx, newloc.x + CEILING(bound_width / 32, 1) - 1),
						newloc.y,
						newloc.z
					)
				)
			if(EAST)
				opposite = locate(
					min(world.maxx, newloc.x + CEILING(bound_width / 32, 1) - 1),
					newloc.y,
					newloc.z
				)
				leaving = block(
					loc,
					locate(
						loc.x,
						min(world.maxy, loc.y + CEILING(bound_height / 32, 1) - 1),
						loc.z
					)
				)
				entering = block(
					opposite,
					locate(
						opposite.x,
						min(world.maxy, opposite.y + CEILING(bound_height / 32, 1) - 1),
						opposite.z
					)
				)
			if(WEST)
				opposite = locate(
					min(world.maxx, loc.x + CEILING(bound_width / 32, 1) - 1),
					loc.y,
					loc.z
				)
				leaving = block(
					opposite,
					locate(
						opposite.x,
						min(world.maxy, opposite.y + CEILING(bound_height / 32, 1) - 1),
						opposite.z
					)
				)
				entering = block(
					newloc,
					locate(
						newloc.x,
						min(world.maxy, newloc.y + CEILING(bound_height / 32, 1) - 1),
						newloc.z
					)
				)

		var/atom/oldloc = loc
		var/area/oldarea = get_area(loc)
		var/area/newarea = get_area(newloc)

		for(var/turf/T as anything in leaving)
			if(!T.Exit(src, get_step(T, direct)))
				return

		var/reverse = turn(direct, 180)

		for(var/turf/T as anything in entering)
			if(!T.Enter(src, get_step(T, reverse)))
				return

		loc = newloc
		. = TRUE

		for(var/turf/T as anything in leaving)
			T.Exited(src, get_step(T, direct))
			for(var/atom/movable/AM as anything in T)
				AM.Uncrossed(src)
		if(oldarea != newarea)
			oldarea.Exited(src, newloc)

		for(var/turf/T as anything in entering)
			T.Entered(src, get_step(T, reverse))
			for(var/atom/movable/AM as anything in T)
				AM.Crossed(src)
		if(oldarea != newarea)
			newarea.Entered(src, oldloc)

	else
		//* single tile handling * //
		// check
		if(!loc.Exit(src, newloc))
			return

		if(!newloc.Enter(src, src.loc))
			return

		// gather
		var/atom/oldloc = loc
		var/area/oldarea = get_area(oldloc)
		var/area/newarea = get_area(newloc)

		// move
		loc = newloc
		. = TRUE

		// exit
		oldloc.Exited(src, newloc)
		if(oldarea != newarea)
			oldarea.Exited(src, newloc)
		for(var/i in oldloc)
			var/atom/movable/thing = i
			thing.Uncrossed(src)

		// enter
		newloc.Entered(src, oldloc)
		if(oldarea != newarea)
			newarea.Entered(src, oldloc)
		for(var/i in loc)
			var/atom/movable/thing = i
			thing.Crossed(src)

/**
 * Move() implementation
 *
 * Only supports moves up to range 1, in any direction including diagonals.
 */
/atom/movable/Move(atom/newloc, direct, step_x, step_y, glide_size_override)
	var/is_multi_tile = bound_width > world.icon_size || bound_height > world.icon_size
	if(is_multi_tile && isturf(newloc))
		newloc = locate(newloc.x + round(step_x / WORLD_ICON_SIZE), newloc.y + round(step_y / WORLD_ICON_SIZE), newloc.z)
	if(!isturf(loc) || !isturf(newloc))
		return FALSE
	if(get_dist(loc, newloc) > 1)
		CRASH("attempted to move longer than 1 get_dist with Move(); please use forceMove!")
	++in_move

	if(isnull(direct))
		// loc, not src, due to multitile.
		direct = get_dir(loc, newloc)
	var/atom/movable/pullee = pulling

	var/turf/T = loc
	if(!moving_from_pull)
		check_pulling()
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
			// The `&& moving_diagonally` checks are so that a force_move taking
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
		--in_move
		return

	if(. && has_buckled_mobs() && !handle_buckled_mob_movement(loc, direct, glide_size_override)) //movement failed due to buckled mob(s)
		return FALSE

	if(.)
		Moved(oldloc, direct)

	if(. && pulling && pulling == pullee && pulling != moving_from_pull) //we were pulling a thing and didn't lose it during our move.
		if(pulling.anchored)
			stop_pulling()
		else
			//puller and pullee more than one tile away or in diagonal position
			var/pull_dir = get_dir(src, pulling)
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

	--in_move

	// legacy
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
				--in_move
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

/**
 * Called after a successful Move(). By this point, we've already moved.
 *
 * Do not do anything that will re-move the atom, or bad things happen.
 * Use spawn(0) to yield behavior until after the movement call stack is done if you want to do that.
 *
 * @params
 * * old_loc is the location prior to the move. Can be null to indicate nullspace.
 * * movement_dir is the direction the movement took place. Can be NONE if it was some sort of teleport.
 * * The forced flag indicates whether this was a forced move, which skips many checks of regular movement.
 * * The old_locs is an optional argument, in case the moved movable was present in multiple locations before the movement.
 * * momentum_change represents whether this movement is due to a "new" force if TRUE or an already "existing" force if FALSE
 **/
/atom/movable/proc/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	SHOULD_CALL_PARENT(TRUE)

	if (!inertia_moving)
		inertia_next_move = world.time + inertia_move_delay
		newtonian_move(movement_dir)


	var/turf/old_turf = get_turf(old_loc)
	var/turf/new_turf = get_turf(src)

	SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, old_loc, movement_dir, forced, old_locs, momentum_change)

	if(old_loc)
		SEND_SIGNAL(old_loc, COMSIG_ATOM_ABSTRACT_EXITED, src)
	if(loc)
		SEND_SIGNAL(loc, COMSIG_ATOM_ABSTRACT_ENTERED, src, old_loc, old_locs)

	if (old_turf?.z != new_turf?.z)
		on_changed_z_level(old_turf?.z, new_turf?.z)

	return TRUE

/**
 * meant for movement with zero side effects. only use for objects that are supposed to move "invisibly" (like camera mobs or ghosts)
 * if you want something to move onto a tile with a beartrap or recycler or tripmine or mouse without that object knowing about it at all, use this
 * most of the time you want forceMove()
 */
/atom/movable/proc/abstract_move(atom/new_loc)
	var/atom/old_loc = loc
	var/direction = get_dir(old_loc, new_loc)
	loc = new_loc
	Moved(old_loc, direction, TRUE)

/**
 * Make sure you know what you're doing if you override or call this.
 *
 * This *must* be a pure proc. You cannot act on the atom if you override this! Use Bump() for that.
 *
 * You probably want CanPass() if you're overriding.
 */
/atom/movable/Cross(atom/movable/AM)
	. = TRUE
	SEND_SIGNAL(src, COMSIG_MOVABLE_CROSS, AM)
	return CanPass(AM, loc)

/**
 * Called when something crosses us.
 *
 * Do not do anything that will re-move the atom, or bad things happen.
 * Use spawn(0) to yield behavior until after the movement call stack is done if you want to do that.
 */
/atom/movable/Crossed(atom/movable/AM, oldloc)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	SEND_SIGNAL(src, COMSIG_MOVABLE_CROSSED, AM)
	throwing?.crossed_by(AM)

/**
 * Make sure you know what you're doing if you override or call this.
 *
 * This *must* be a pure proc. You cannot act on the atom if you override this! Use Bump() for that.
 */
/atom/movable/Uncross(atom/movable/AM, atom/newloc)
	. = TRUE
	if(SEND_SIGNAL(src, COMSIG_MOVABLE_UNCROSS, AM) & COMPONENT_MOVABLE_BLOCK_UNCROSS)
		return FALSE
	if(isturf(newloc) && !CheckExit(AM, newloc))
		return FALSE

/**
 * Called when something uncrosses us.
 *
 * Do not do anything that will re-move the atom, or bad things happen.
 * Use spawn(0) to yield behavior until after the movement call stack is done if you want to do that.
 */
/atom/movable/Uncrossed(atom/movable/AM)
	SEND_SIGNAL(src, COMSIG_MOVABLE_UNCROSSED, AM)

/atom/movable/Bump(atom/A)
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
				buckle_mob(M, BUCKLE_OP_FORCE | BUCKLE_OP_IGNORE_LOC | BUCKLE_OP_SILENT, null, oldbuckled[M])

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

	++in_move

	var/atom/oldloc = loc
	var/is_multi_tile = bound_width > world.icon_size || bound_height > world.icon_size

	if(buckled_mobs)
		unbuckle_all_mobs(BUCKLE_OP_FORCE)
	pulledby?.stop_pulling()
	if(pulling)
		stop_pulling()

	if(destination)
		var/same_loc = oldloc == destination
		var/area/old_area = get_area(oldloc)
		var/area/destarea = get_area(destination)

		moving_diagonally = null

		if(!same_loc)
			if(is_multi_tile && isturf(destination))
				// gather
				var/list/old_locs = locs // implicit Copy() due to locs being special byond list
				var/list/new_locs = block(
					destination,
					locate(
						min(world.maxx, destination.x + ROUND_UP(bound_width / 32)),
						min(world.maxy, destination.y + ROUND_UP(bound_height / 32)),
						destination.z
					)
				)

				// move
				loc = destination

				// exit
				if(old_area && old_area != destarea)
					old_area.Exited(src)
				for(var/atom/left_loc as anything in old_locs - new_locs)
					left_loc.Exited(src, oldloc)
					for(var/atom/movable/AM as anything in left_loc)
						AM.Uncrossed(src)

				// enter
				if(old_area && old_area != destarea)
					destarea.Entered(src)
				for(var/atom/entering_loc as anything in new_locs - old_locs)
					entering_loc.Entered(src, oldloc)
					for(var/atom/movable/AM as anything in entering_loc)
						AM.Cross(src)

				// moved
				Moved(oldloc, NONE, TRUE)

			else
				// move
				loc = destination

				// exit
				if(!isnull(oldloc))
					oldloc.Exited(src, destination)
					if(old_area && old_area != destarea)
						old_area.Exited(src)
				for(var/atom/movable/AM in oldloc)
					AM.Uncrossed(src)

				// enter
				destination.Entered(src, oldloc)
				if(destarea && old_area != destarea)
					destarea.Entered(src)
				for(var/atom/movable/AM in destination)
					if(AM == src)
						continue
					AM.Crossed(src, oldloc)

				// moved
				Moved(oldloc, NONE, TRUE)

		. = TRUE

	//If no destination, move the atom into nullspace (don't do this unless you know what you're doing)
	else
		. = TRUE

		if(is_multi_tile)
			var/list/old_locs = locs // implicit Copy() due to locs being special byond list
			var/area/old_area = get_area(src)
			loc = null
			if(!isnull(old_area))
				old_area.Exited(src)
			for(var/atom/A as anything in old_locs)
				A.Exited(src, null)
		else
			loc = null
			if(!isnull(oldloc))
				var/area/old_area = get_area(loc)
				oldloc.Exited(src, null)
				if(old_area)
					old_area.Exited(src)

		Moved(oldloc, NONE, TRUE)

	--in_move

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


//? Move Force
// todo: this system is shit

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

//? Direction

/**
 * Hook for running code when a dir change occurs
 */
/atom/proc/setDir(newdir)
	if(dir == newdir)
		return FALSE
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_DIR_CHANGE, dir, newdir)
	dir = newdir

	if (light_source_solo)
		if (light_source_solo.light_angle)
			light_source_solo.source_atom.update_light()
	else if (light_source_multi)
		var/datum/light_source/L
		for (var/thing in light_source_multi)
			L = thing
			if (L.light_angle)
				L.source_atom.update_light()
	return TRUE

//? Z Transit

/**
 * Called when we change z-levels. This works while inside contents.
 *
 * Do not do anything that will re-move the atom, or bad things happen.
 * Use spawn(0) to yield behavior until after the movement call stack is done if you want to do that.
 */
/atom/movable/proc/on_changed_z_level(old_z, new_z)
	SEND_SIGNAL(src, COMSIG_MOVABLE_Z_CHANGED, old_z, new_z)
	for(var/item in src) // Notify contents of Z-transition. This can be overridden IF we know the items contents do not care.
		var/atom/movable/AM = item
		AM.on_changed_z_level(old_z, new_z)

//? Anchored

/**
 * Sets the anchored variable
 *
 * @params
 * * anchorvalue - new anchored value
 *
 * @return TRUE / FALSE on if anchored changed from its value
 */
/atom/movable/proc/set_anchored(anchorvalue)
	SHOULD_CALL_PARENT(TRUE)
	if(anchored == anchorvalue)
		return
	. = anchored
	anchored = anchorvalue
	SEND_SIGNAL(src, COMSIG_MOVABLE_SET_ANCHORED, anchorvalue)

//? Pass Flags

/**
 * for regexing
 */
/atom/movable/proc/check_pass_flags(flags)
	return pass_flags & flags

//? Movement Types

/atom/movable/proc/update_movement_type()
	var/old_type = movement_type & MOVEMENT_TYPES

	#define RESET_MOVE_TYPE(type) movement_type = (movement_type & ~(movement_type & MOVEMENT_TYPES)) | type
	if(HAS_TRAIT(src, TRAIT_ATOM_PHASING))
		RESET_MOVE_TYPE(MOVEMENT_PHASING)
	else if(HAS_TRAIT(src, TRAIT_ATOM_FLYING))
		RESET_MOVE_TYPE(MOVEMENT_FLYING)
	else if(HAS_TRAIT(src, TRAIT_ATOM_FLOATING))
		RESET_MOVE_TYPE(MOVEMENT_FLOATING)
	else
		RESET_MOVE_TYPE(MOVEMENT_GROUND)
	#undef RESET_MOVE_TYPE

	var/new_type = movement_type & MOVEMENT_TYPES

	if(old_type == new_type)
		return

	on_update_movement_type(old_type, new_type)

/atom/movable/proc/on_update_movement_type(old_type, new_type)

/atom/movable/proc/add_atom_flying(source)
	ADD_TRAIT(src, TRAIT_ATOM_FLYING, source)
	update_movement_type()

/atom/movable/proc/add_atom_phasing(source)
	ADD_TRAIT(src, TRAIT_ATOM_PHASING, source)
	update_movement_type()

/atom/movable/proc/add_atom_floating(source)
	ADD_TRAIT(src, TRAIT_ATOM_FLOATING, source)
	update_movement_type()

/atom/movable/proc/remove_atom_flying(source)
	REMOVE_TRAIT(src, TRAIT_ATOM_FLYING, source)
	update_movement_type()

/atom/movable/proc/remove_atom_phasing(source)
	REMOVE_TRAIT(src, TRAIT_ATOM_PHASING, source)
	update_movement_type()

/atom/movable/proc/remove_atom_floating(source)
	REMOVE_TRAIT(src, TRAIT_ATOM_FLOATING, source)
	update_movement_type()

//? Glide Size

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
