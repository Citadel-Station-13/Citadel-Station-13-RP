/**
 * Gets all contents of contents and returns them all in a list.
 */
/atom/proc/get_all_contents(target)
	var/list/processing_list = list(src)
	var/i = 0
	var/lim = 1
	while(i < lim)
		var/atom/A = processing_list[++i]
		processing_list += A.contents
		lim = processing_list.len
	return processing_list

/**
 * Gets all contents of contents and returns them all in a list, ignoring atoms that match a typecache
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
 * checks if something is in our contents or the contents of our contents up to infinite depth
 *
 * todo: add depth limit
 */
/atom/proc/is_in_nested_contents(atom/movable/thing)
	var/atom/iter = thing.loc
	while(iter)
		if(iter == src)
			return TRUE
		iter = iter.loc
	return FALSE
