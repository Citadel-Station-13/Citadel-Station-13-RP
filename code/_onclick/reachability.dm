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
 * time complexity analysis of
 * "person tries to reach into a 3 nested deep item in
 * a pill bottle in a box in a backpack from standing"
 *
 * - directaccesscache cost
 * - first check fails
 * - first for loop runs; we're on turf, so tadj gets set and we return
 * - isarea check runs and fails
 * - check cache list init, same with other vars
 * - for loop runs 3 times, hits turf, doesn't add turf area
 * - TurfAdjacency is checked since it isn't a ranged attack
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
	var/turf/tadj
	// loc checking
	var/atom/l = loc
	// reach out from where we are as far as we can bound by depth
	for(var/i in 1 to depth)
		if(!l)
			break
		if(isturf(l))
			tadj = l
			break
		if(!l.CanReachOut(src, target, tool, dc))
			break
		l = l.loc
	// if target isn't anywhere (this should be at the top but maybe someone
	// snowflakes a clickable object in directaccess but without loc someday)
	// we can only access through DC
	if(!target.loc)
		return !!dc[target]
	// special checks
	if(isarea(target))
		// area checks don't support range, because
		// 1. why are you trying to reach an are awith this proc
		// 2. it would be expensive as shit and require a snowflake check
		//    that i have no intention of writing right now
		return tadj && (l.loc == target)
	else if(isturf(target))
		// turf checks are just an adjacency check
		return tadj?.TurfAdjacency(target)

	// now that cache is assembled and turf is set, go to main loop

	// we don't cut or make lists because heehoo byond speed ecks dee
	// we just advance
	// this has the advantage of sped up protection against infinite recursion
	// in the old system we used a closed_cache[thing] = true to prevent
	// infinite loops, now it's built in, and iteration is just as fast!

	// check cache
	var/list/cc = list(target.loc = TRUE)
	// current index in check cache
	var/i = 1
	// did we reach turf? turf heuristic - usually the first turf we found
	var/turf/th
	// current length
	var/cl = 1
	// reach *upwards* from the target
	for(var/d in 1 to depth)
		cl = length(cc)
		if(i > cl)
			// hit top, didn't find, break
			break
		for(i in i to cl)
			l = cc[i]
			// process the rest of checking
			if(!l.CanReachIn(src, target, tool, cc))
				// couldn't reach in, l is irrelevant
				continue
			if(dc[l])
				// found
				return TRUE
			if(isturf(l) && !th)
				// is turf; turf adjacency enabled
				th = l
			if(isarea(l.loc))
				// don't recurse into areas
				continue
			cc[l.loc] = TRUE
		// don't overlap
		++i
	if(!(tadj && th))
		// didn't hit both, fail
		return FALSE
	// at this point, we're on a turf
	if(range == 1)
		// most common case: reach directly aronud yourself
		return tadj.TurfAdjacency(th, target, src)
	else if(!range)
		// rare but cheap case: only stuff on your tile
		return th == tadj
	else
		// less common but expensive case - long range tool reach
		var/atom/movable/reachability_delegate/D = new(tadj)
		D.pass_flags |= pass_flags
		// next turf
		var/turf/n = D.loc
		for(i in 1 to range)
			ASSERT(isturf(n))
			if(n.TurfAdjacency(th))
				// succeeded
				qdel(D)
				return TRUE
			// dumb directional pathfinding both for cheapness and for practical purposes
			// so you can't snake-arms round a row of windows or something crazy
			n = get_step(D, get_dir(D, th))
			if(!D.Move(n))
				// failed
				qdel(D)
				return FALSE
			// keep going
		// at this point, we failed
		qdel(D)
		return FALSE

/**
 * quick and dirty reachability check
 */
/atom/movable/proc/CheapReachability(atom/target, depth = DEFAULT_REACHABILITY_DEPTH, range, obj/item/tool)
	var/turf/curr = target.loc
	var/turf/source
	if(isturf(curr))
		source = get_turf(src)
		if(!source)
			return FALSE
		return curr.TurfAdjacency(source)
	do
		if(curr == src)
			return TRUE
		if(!curr)
			return FALSE
		curr = curr.loc
	while(!isturf(curr))
	source = get_turf(src)
	if(!source)
		return FALSE
	return curr.TurfAdjacency(source)

/atom/movable/reachability_delegate
	pass_flags = ATOM_PASS_CLICK | ATOM_PASS_TABLE
	invisibility = INVISIBILITY_ABSTRACT

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

//! Clicking out of - for ranged attack chains
/**
 * called to see if we're allowed to proc ranged_attack_chain from in here at a target
 *
 * this proc needs refactored at some point to allow for complexity if necessary
 * but for now it works so don't fuck with it
 */
/atom/proc/AllowClick(atom/movable/mover, atom/target, obj/item/tool)
	return FALSE

/turf/AllowClick(atom/movable/mover, atom/target, obj/item/tool)
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
	for(var/obj/O in contents)
		if(O.obj_flags & OBJ_PREVENT_CLICK_UNDER)
			return TRUE
	return FALSE
