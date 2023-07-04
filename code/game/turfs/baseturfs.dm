// This is a typepath to just sit in baseturfs and act as a marker for other things.
/turf/baseturf_skipover
	name = "Baseturf skipover placeholder"
	desc = "This shouldn't exist"

/turf/baseturf_skipover/Initialize(mapload)
	. = ..()
	stack_trace("[src]([type]) was instanced which should never happen. Changing into the next baseturf down...")
	ScrapeAway()

/turf/baseturf_skipover/shuttle
	name = "Shuttle baseturf skipover"
	desc = "Acts as the bottom of the shuttle, if this isn't here the shuttle floor is broken through."

/turf/baseturf_bottom
	name = "Z-level baseturf placeholder"
	desc = "Marker for z-level baseturf, usually resolves to space."
	baseturfs = /turf/baseturf_bottom

/**
 * created baseturfs, keyed by their top turf
 */
GLOBAL_LIST_EMPTY(created_baseturf_lists)

/**
 * Assembles baseturfs from a certain root
 *
 * @params
 * * root - Optional; A turf or a list of turfs to use instead of current baseturfs
 */
/turf/proc/assemble_baseturfs(turf/root)
	var/turf/target
	if(root)
		if(length(root))
			// was given list, just dedupe and go
			baseturfs = baseturfs_string_list(root, src)
			return
		// (assume) must be path
		target = root
	else
		// use our own
		if(length(baseturfs))
			// already a list
			// dedupe
			baseturfs = baseturfs_string_list(baseturfs, src)
			return
		else if(baseturfs == /turf/baseturf_bottom)
			// we are going to """waste""" an op to fastpath this
			// because so many turfs use this it's a net gain
			return
		else if(isnull(baseturfs)) // null check; let it runtime if it's not null or path
			target = initial(baseturfs) || type // This should never happen but just in case...
			stack_trace("baseturfs var was null for [type]. Failsafe activated and it has been given a new baseturfs value of [target].")
		else
			target = baseturfs

	// target at this point should be a path
	var/list/found = GLOB.created_baseturf_lists[target]
	if(isnull(found))
		// not found
		// we have to build the list then
		var/turf/next = initial(target.baseturfs)
		if(next == target)
			// if we're the same type..
			baseturfs = target
			GLOB.created_baseturf_lists[target] = target
			return
		var/list/built = list(target)
		for(var/i = 0; target != next; ++i)
			if(i > 20)
				// A baseturfs list over 20 members long is silly
				// Because of how this is all structured it will only runtime/message once per type
				stack_trace("A turf <[type]> created a baseturfs list over 100 members long. This is most likely an infinite loop.")
				message_admins("A turf <[type]> created a baseturfs list over 100 members long. This is most likely an infinite loop.")
				break
			built.Insert(1, next)
			target = next
			next = initial(target.baseturfs)
		baseturfs = (GLOB.created_baseturf_lists[built[length(built)]] = built)
		return
	// found
	if(ispath(found))
		// is path, just directly set
		baseturfs = found
		return
	// must be a list at this point
	// thus, because we can *assume* no one is going to touch baseturfs,
	// we DO NOT use baseturfs_string_list because we don't need to dedupe when this should
	// never be changed / stay cached anyways.
	baseturfs = found
