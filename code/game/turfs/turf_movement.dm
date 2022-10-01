var/const/enterloopsanity = 100
/turf/Entered(atom/movable/AM)
	..()

	if(LAZYLEN(acting_automata))
		for(var/datum/automata/A as anything in acting_automata)
			A.act_cross(AM, acting_automata[A])

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
		if(isliving(M) && (M.movement_type & GROUND))
			var/mob/living/L = M
			L.handle_footstep(src)

//There's a lot of QDELETED() calls here if someone can figure out how to optimize this but not runtime when something gets deleted by a Bump/CanAllowThrough/Cross call, lemme know or go ahead and fix this mess - kevinz000
/turf/Enter(atom/movable/mover, atom/oldloc)
	// Do not call ..()
	// Byond's default turf/Enter() doesn't have the behaviour we want with Bump()
	// By default byond will call Bump() on the first dense object in contents
	// Here's hoping it doesn't stay like this for years before we finish conversion to step_
	var/atom/firstbump
	var/CanPassSelf = CanPass(mover, src)
	if(CanPassSelf || (mover.movement_type & UNSTOPPABLE))
		for(var/i in contents)
			if(QDELETED(mover))
				return FALSE		//We were deleted, do not attempt to proceed with movement.
			if(i == mover || i == mover.loc) // Multi tile objects and moving out of other objects
				continue
			var/atom/movable/thing = i
			if(!thing.Cross(mover))
				if(QDELETED(mover))		//Mover deleted from Cross/CanAllowThrough, do not proceed.
					return FALSE
				if(mover.movement_type & UNSTOPPABLE)
					mover.Bump(thing)
					continue
				else
					if(!firstbump || ((thing.layer > firstbump.layer || thing.flags & ON_BORDER) && !(firstbump.flags & ON_BORDER)))
						firstbump = thing
	if(QDELETED(mover))					//Mover deleted from Cross/CanAllowThrough/Bump, do not proceed.
		return FALSE
	if(!CanPassSelf)	//Even if mover is unstoppable they need to bump us.
		firstbump = src
	if(firstbump)
		mover.Bump(firstbump)
		return !QDELETED(mover) && (mover.movement_type & UNSTOPPABLE)
	return TRUE

/turf/Exit(atom/movable/mover, atom/newloc)
	. = ..()
	if(!. || QDELETED(mover))
		return FALSE
	for(var/i in contents)
		if(i == mover)
			continue
		var/atom/movable/thing = i
		if(!thing.Uncross(mover, newloc))
			if(thing.flags & ON_BORDER)
				mover.Bump(thing)
			if(!(mover.movement_type & UNSTOPPABLE))
				return FALSE
		if(QDELETED(mover))
			return FALSE		//We were deleted.
