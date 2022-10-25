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
