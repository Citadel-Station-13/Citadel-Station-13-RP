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
			// was given list, just stringify and go
			baseturfs = baseturfs_string_list(root, src)
			return
		// (assume) must be path
		target = root
	else
		// use our own
		if(length(baseturfs))
			// already a list
			return
		else if(baseturfs == /turf/baseturf_bottom)
			// we are going to """waste""" an op to fastpath this
			// because so many turfs use this it's a net gain
			return
		else if(isnull(baseturfs)) // null check; let it runtime if it's not null or path
			current_target = initial(baseturfs) || type // This should never happen but just in case...
			stack_trace("baseturfs var was null for [type]. Failsafe activated and it has been given a new baseturfs value of [current_target].")
		else
			target = baseturfs

	// target at this point should be a path
	. = GLOB.created_baseturf_lists[target]
	if(isnull(.))
		// not found

		return
	// found
	if(ispath(.))
		baseturfs = .
		return
	// must be a list at this point



	var/list/created_baseturf_lists = GLOB.created_baseturf_lists

	// If we've made the output before we don't need to regenerate it
	if(created_baseturf_lists[current_target])
		var/list/premade_baseturfs = created_baseturf_lists[current_target]
		if(length(premade_baseturfs))
			baseturfs = baseturfs_string_list(premade_baseturfs.Copy(), src)
		else
			baseturfs = baseturfs_string_list(premade_baseturfs, src)
		return baseturfs

	var/turf/next_target = initial(current_target.baseturfs)
	//Most things only have 1 baseturf so this loop won't run in most cases
	if(current_target == next_target)
		baseturfs = current_target
		created_baseturf_lists[current_target] = current_target
		return current_target
	var/list/new_baseturfs = list(current_target)
	for(var/i=0;current_target != next_target;i++)
		if(i > 100)
			// A baseturfs list over 100 members long is silly
			// Because of how this is all structured it will only runtime/message once per type
			stack_trace("A turf <[type]> created a baseturfs list over 100 members long. This is most likely an infinite loop.")
			message_admins("A turf <[type]> created a baseturfs list over 100 members long. This is most likely an infinite loop.")
			break
		new_baseturfs.Insert(1, next_target)
		current_target = next_target
		next_target = initial(current_target.baseturfs)

	baseturfs = baseturfs_string_list(new_baseturfs, src)
	created_baseturf_lists[new_baseturfs[new_baseturfs.len]] = new_baseturfs.Copy()
	return new_baseturfs
