//! Reachability System
/**
 * Checks if we can reach something.
 * Only supports things that are right next to us, for now.
 */
/atom/movable/proc/CanReach(atom/target, obj/item/tool, max_depth = )
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

#warn overrides for reachability for:
#warn lockers
#warn mobs

//! Reaching out of
/**
 * called to see if we can reach out of this atom
 */
/atom/proc/CanReachOut(atom/user, atom/target, atom/from, obj/item/tool)
	return FALSE

//! Reaching into
/**
 * called to see if we can reach into this atom
 */
/atom/proc/CanReachIn(atom/user, atom/target, atom/from, obj/item/tool)
	return TRUE

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
