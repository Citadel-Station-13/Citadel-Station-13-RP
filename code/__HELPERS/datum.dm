/**
 * Check if a datum has not been deleted and is a valid source.
 */
/proc/is_valid_src(datum/target)
	if(istype(target))
		return !QDELETED(target)
	return FALSE

/**
 * async proc call. True beauty.
 */
/proc/call_async(datum/source, proctype, list/arguments)
	set waitfor = FALSE
	return call(source, proctype)(arglist(arguments))
