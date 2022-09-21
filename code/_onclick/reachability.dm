//! Reachability System
/**
 * Checks if we can reach something.
 *
 * How this works:
 * - we check our direct access
 * - we "reach outwards" as much as we can. If we reach the turf, cool! if not, those atoms are added
 *   to direct access list. this sounds slow, but isn't bad worst case unless someone's somehow nested
 *   in a thousand atoms or a proc breaks.
 * - max depth is a thing; it applies to both reaching out, and reaching in.
 *   it however applies separately, e.g. you can reach out of a backpack inside a locker
 *   (you can't in game because those objects set their procs but for the sake of argument pretend you can)
 *   you can still reach a pill bottle inside a box inside a backpack as opposed to just on the turf
 *   or in the backpack, assuming max_depth is set to 3
 * - range: when we reach the turf, we'll do our best-estimate byond step_towards path-cast
 *   to try to get TurfAdjacency to the user
 *
 * @params
 * - target - the target
 * - depth - max depth
 * - range - max range
 * - tool - the item we're using to reach; not important
 */
/atom/movable/proc/Reachability(atom/target, depth = DEFAULT_REACHABILITY_DEPTH, range = 1, obj/item/tool)
	if(!target)
		// apologies sir, you may not grasp the void...
		return FALSE
	// direct cache - check if we can access something using if dc[atom]
	var/list/dc = DirectAccessCache()
	// optimization - a lot of the time we're clicking on ourselves/things on ourselves
	if(dc[target])
		return TRUE
	// turf adjacency enabled? stores if we can try to path to our turf
	var/tadj
	// loc checking
	var/atom/l = loc
	// reach out from where we are as far as we can bound by depth
	for(var/i in 1 to depth)
		if(!l)
			break
		if(isturf(l))
			tadj = TRUE
			break
		if(!l.CanReachOut(src, target, tool, dc))
			break
		l = l.loc

	// special checks
	if(isarea(target))
		return tadj && (l.loc == target)

	// now that cache is assembled and turf is set, go to main loop

	// we don't cut or make lists because heehoo byond speed ecks dee
	// we just advance
	// this has the advantage of sped up protection against infinite recursion
	// in the old system we used a closed_cache[thing] = true to prevent
	// infinite loops, now it's built in, and iteration is just as fast!

	// check cache
	var/list/cc = list(target = TRUE)
	// current index in check cache
	var/i = 1
	// reassign current loc to target loc
	l = target.loc
	// reach *upwards* from the target
	for(var/i in 1 to depth)
		if(!l)
			// null loc - if we haven't detected by now, we shouldn't bother
			return FALSE
		if(!l.CanReachIn(src, target, tool, cc))
			// failed; if we can't reach by now, we shouldn't bother
			return FALSE

		#warn aough


	while(i <= length(cc))


	// backwards depth-limited breadth-first-search to see if the target is "in" anything "adjacent" to us.
	var/list/directly_accessible = DirectAccess()

	var/depth = 0

	var/list/closed = list()
	var/list/checking = list(target)
	var/list/next
	while(checking.len && depth <= max_depth)
		next = list()
		++depth

		for(var/atom/A in checking)	// filter nulls
			if(closed[A] || isarea(A))	// nah!
				continue
			closed[A] = TRUE
			if(SEND_SIGNAL())
			if(!A.loc)
				continue

//! Direct Access
/**
 * checks what we can directly reach
 */
/atom/movable/proc/DirectAccess()
	return list(src, loc)

/mob/DirectAccess()
	return ..() + get_equipped_items()

/**
 * gets DirectAccess as a hashed list for quick lookups
 */
/atom/movable/proc/DirectAccessCache()
	. = list()
	// procs like these make me wish ss13 was run on node.js or something equally stupid
	// return Object.assign({}, ...data.map((atom) => ({[atom]: true})));
	for(var/i in DirectAccess())
		.[i] = TRUE



/atom/movable/proc/CanReach(atom/ultimate_target, obj/item/tool, view_only = FALSE)
	// A backwards depth-limited breadth-first-search to see if the target is
	// logically "in" anything adjacent to us.
	var/list/direct_access = DirectAccess()
	var/depth = 1 + (view_only ? STORAGE_VIEW_DEPTH : INVENTORY_DEPTH)

	var/list/closed = list()
	var/list/checking = list(ultimate_target)
	while (checking.len && depth > 0)
		var/list/next = list()
		--depth

		for(var/atom/target in checking)  // will filter out nulls
			if(closed[target] || isarea(target))  // avoid infinity situations
				continue
			closed[target] = TRUE
			if(isturf(target) || isturf(target.loc) || (target in direct_access)) //Directly accessible atoms
				if(Adjacent(target) || (tool && CheckToolReach(src, target, tool.reach))) //Adjacent or reaching attacks
					return TRUE

			if (!target.loc)
				continue

			if(!(SEND_SIGNAL(target.loc, COMSIG_ATOM_CANREACH, next) & COMPONENT_BLOCK_REACH) && target.loc.canReachInto(src, ultimate_target, next, view_only, tool))
				next += target.loc

		checking = next
	return FALSE


/proc/CheckToolReach(atom/movable/here, atom/movable/there, reach)
	if(!here || !there)
		return
	switch(reach)
		if(0)
			return FALSE
		if(1)
			return FALSE //here.Adjacent(there)
		if(2 to INFINITY)
			var/obj/dummy = new(get_turf(here))
			dummy.pass_flags |= PASSTABLE
			dummy.invisibility = INVISIBILITY_ABSTRACT
			for(var/i in 1 to reach) //Limit it to that many tries
				var/turf/T = get_step(dummy, get_dir(dummy, there))
				if(dummy.CanReach(there))
					qdel(dummy)
					return TRUE
				if(!dummy.Move(T)) //we're blocked!
					qdel(dummy)
					return
			qdel(dummy)

#warn overrides for reachability for:
#warn lockers
#warn mobs

//! Reaching out of
/**
 * called to see if we can reach out of this atom
 *
 * **When overriding, DO NOT FUCK WITH CACHE unless you KNOW WHAT YOU ARE DOING.**
 *
 * @params
 * - mover - thing reaching
 * - target - what we're reaching at
 * - tool - what mover is using to reach with if applicable
 * - cache - direct access to the "directly open" cache list. Add things to this with cache[obj] = TRUE
 */
/atom/proc/CanReachOut(atom/movable/mover, atom/target, obj/item/tool, list/cache)
	// todo: signal when we care about signals
	return FALSE

//! Reaching into
/**
 * called to see if we can reach into this atom
 *
 * **When overriding, DO NOT FUCK WITH CACHE unless you KNOW WHAT YOU ARE DOING.**
 *
 * @params
 * - mover - thing reaching
 * - target - what we're reaching at
 * - tool - what mover is using to reach with if applicable
 * - cache - direct access to the "checking" cache list. Add things to this with cache[obj] = TRUE
 */
/atom/proc/CanReachIn(atom/movable/mover, atom/target, obj/item/tool, list/cache)
	// todo: signal when we care about signals
	return TRUE

//! Obfuscation
/**
 * is the atom obscured by a OBJ_PREVENT_CLICK_UNDER object above it
 */
/atom/proc/IsObsecured()
	if(!isturf(loc))
		return FALSE
	var/turf/T = get_turf_pixel(src)
	if(!T)
		return FALSE
	for(var/obj/O in T)
		if((O.obj_flags & OBJ_PREVENT_CLICK_UNDER) && O.layer > layer && O.plane >= plane)
			return TRUE
	return FALSE

/turf/IsObsecured()
	for(var/obj/O in T)
		if(O.obj_flags & OBJ_PREVENT_CLICK_UNDER)
			return TRUE
	return FALSE
