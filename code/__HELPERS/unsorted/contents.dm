/**
 * Gets all contents of contents and returns them all in a list.
 */
/atom/proc/get_all_contents(target)
	var/list/processing_list = list(src)
	var/i = 0
	var/lim = 1
	if(target)
		. = list()
		while(i < lim)
			var/atom/A = processing_list[++i]
			/**
			 * Byond does not allow things to be in multiple contents, or double parent-child hierarchies, so only += is needed.
			 * This is also why we don't need to check against assembled as we go along.
			 */
			processing_list += A.contents
			lim = processing_list.len
			if(istype(A, target))
				. += A
	else
		while(i < lim)
			var/atom/A = processing_list[++i]
			processing_list += A.contents
			lim = processing_list.len
		return processing_list

/**
 * Gets all contents of an atom ignoring the given typecache.
 * * Ignored atoms will not be iterated into.
 */
/atom/proc/get_all_contents_ignoring(list/ignore_typecache)
	if(!length(ignore_typecache))
		return get_all_contents()
	var/list/processing = list(src)
	. = list()
	var/i = 0
	var/lim = 1
	while(i < lim)
		var/atom/A = processing[++i]
		if(!ignore_typecache[A.type])
			processing += A.contents
			lim = processing.len
			. += A

/**
 * Gets all contents of an atom matching the given typecache filter.
 * * Unlike `get_all_contents_ignoring`, non-matching atoms will
 *   still be iterated into, as their contents may contain matches.
 */
/atom/proc/get_all_contents_filtered(list/filter_typecache)
	. = list()
	if(!length(filter_typecache))
		return
	var/list/processing = list(src)
	var/i = 0
	var/lim = 1
	while(i < lim)
		var/atom/A = processing[++i]
		processing += A.contents
		lim = processing.len
		if(filter_typecache[A.type])
			. += A
