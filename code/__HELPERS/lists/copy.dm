/**
 * Copies a list, and all lists inside it recusively.
 * Does not copy any other reference type.
 */
/proc/deep_copy_list(list/l)
	if(!islist(l))
		return l
	. = l.Copy()
	for(var/i = 1 to l.len)
		var/key = .[i]
		if(isnum(key))
			//! Numbers cannot ever be associative keys.
			continue
		var/value = .[key]
		if(islist(value))
			value = deep_copy_list(value)
			.[key] = value
		if(islist(key))
			key = deep_copy_list(key)
			.[i] = key
			.[key] = value
