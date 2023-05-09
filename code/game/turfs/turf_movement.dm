/**
 * Checks if an atom can enter us.
 * For multi tile objects, oldloc is the turf that they're moving to us from, meaning it's always adjacent, not their real loc.
 *
 * Side effects: calls Bump() on top-most blocker, if any, or all blocking objects if atom is MOVEMENT_UNSTOPPABLE.
 *
 * Will return FALSE and terminate if the mover is moved away by a bump.
 */
/turf/Enter(atom/movable/mover, atom/oldloc)
	// Do not call ..()
	// Byond's default turf/Enter() doesn't have the behaviour we want with Bump()
	// By default byond will call Bump() on the first dense object in contents
	// Here's hoping it doesn't stay like this for years before we finish conversion to step_
	// todo: signal
	var/atom/firstbump
	var/CanPassSelf = CanPass(mover, src)
	var/atom/mover_loc = mover.loc
	var/ignore_bumps = mover.movement_type & MOVEMENT_UNSTOPPABLE
	if(CanPassSelf || ignore_bumps)
		for(var/atom/movable/thing as anything in contents)
			if(thing == mover) // multi tile objects
				continue
			if(thing.Cross(mover))
				continue
			if(ignore_bumps)
				mover.Bump(thing)
				if(mover.loc != mover_loc) // deleted or yanked out
					return FALSE
				continue
			if(!firstbump || ((thing.layer > firstbump.layer || thing.atom_flags & ATOM_BORDER) && !(firstbump.atom_flags & ATOM_BORDER)))
				firstbump = thing
	if(!CanPassSelf)	//Even if mover is unstoppable they need to bump us.
		firstbump = src
	if(firstbump)
		mover.Bump(firstbump)
		return ignore_bumps && mover.loc == mover_loc
	return TRUE

/**
 * Checks if an atom can exit us.
 * For multi tile objects, oldloc is the turf that they're moving from us to, meaning it's always adjacent, not their real loc.
 *
 * Side effects: calls Bump() on top-most blocker, if any, or all blocking objects if atom is MOVEMENT_UNSTOPPABLE.
 *
 * Will return FALSE and terminate if the mover is moved away by a bump.
 */
/turf/Exit(atom/movable/mover, atom/newloc)
	// atom/Exit() overridden!
	// todo: signal
	var/ignore_bumps = mover.movement_type & MOVEMENT_UNSTOPPABLE
	for(var/atom/movable/thing as anything in contents)
		if(thing == mover)
			continue
		if(!thing.Uncross(mover, newloc))
			if(thing.atom_flags & ATOM_BORDER)
				mover.Bump(thing)
			if(!ignore_bumps)
				return FALSE
			if(mover.loc != src) // deleted or yanked out
				return FALSE
	return TRUE

/turf/Entered(atom/movable/AM)
	..()

	if(LAZYLEN(acting_automata))
		for(var/datum/automata/A as anything in acting_automata)
			A.act_cross(AM, acting_automata[A])

	// If an opaque movable atom moves around we need to potentially update visibility.
	if(AM?.opacity && !has_opaque_atom)
		has_opaque_atom = TRUE // Make sure to do this before reconsider_lights(), incase we're on instant updates. Guaranteed to be on in this case.
		reconsider_lights()
		#ifdef AO_USE_LIGHTING_OPACITY
		// Hook for AO.
		regenerate_ao()
		#endif

	/**
	 * everything below this is legacy and deserves to burn in fire
	 * ESPECIALLY vore flying overrides
	 */

	if(ismob(AM))
		var/mob/M = AM
		if(!M.lastarea)
			M.lastarea = get_area(M.loc)
		if(M.flying) // This overwrites the above is_space without touching it all that much.
			M.make_floating(1)
		else if(!is_space())
			M.make_floating(0)
		if(isliving(M) && (M.movement_type & MOVEMENT_GROUND))
			var/mob/living/L = M
			L.handle_footstep(src)
