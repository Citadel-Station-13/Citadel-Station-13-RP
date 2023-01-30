GLOBAL_LIST_EMPTY(string_lists)

#define STRING_LIST_IMPL(V) \
	var/string_id = V.Join("-"); \
	. = GLOB.string_lists[string_id]; \
	if(.){ \
		return; \
	} \
	return GLOB.string_lists[string_id] = V

/**
 * Caches lists with non-numeric stringify-able values (text or typepath).
 */
/proc/string_list(list/values)
	STRING_LIST_IMPL(values)

/**
 * A wrapper for baseturf string lists, to offer support of non list values, and a stack_trace if we have major issues.
 */
/proc/baseturfs_string_list(list/values, turf/baseturf_holder)
	if(!islist(values))
		return values //baseturf things
	// return values
	if(length(values) > 10)
		stack_trace("The baseturfs list of [baseturf_holder] at [baseturf_holder.x], [baseturf_holder.y], [baseturf_holder.x] is [length(values)], it should never be this long, investigate. I've set baseturfs to a flashing wall as a visual queue")
		baseturf_holder.ChangeTurf(/turf/baseturfs_ded, list(/turf/baseturfs_ded), flags = CHANGETURF_FORCEOP)
		var/list/this = list(/turf/baseturfs_ded)
		STRING_LIST_IMPL(this)
	STRING_LIST_IMPL(values)

/turf/baseturfs_ded
	name = "Report this"
	desc = "It looks like base turfs went to the fucking moon, TELL YOUR LOCAL CODER TODAY"
	icon = 'icons/turf/debug.dmi'
	icon_state = ""
