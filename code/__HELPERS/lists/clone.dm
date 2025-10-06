/**
 * Makes a deep clone of a list.
 *
 * * Any datum-types in the list must have clone() implemented.
 * * This is somewhat expensive. Use sparingly.
 * * Null is passed back as null.
 *
 * Valid datatypes that can be cloned:
 *
 * * numbers
 * * strings
 * * lists
 * * datums with clone() implemented
 */
/proc/deep_clone_list(list/L)
	var/list/copy = L?.Copy()
	for(var/i in 1 to length(copy))
		var/key = copy[i]
		var/value = copy[key]
		// clone key
		key = deep_clone_value(key)
		copy[i] = key
		// clone value if it's there
		if(isnull(value))
			continue
		copy[key] = deep_clone_value(value)
	return copy

/proc/deep_clone_value(val)
	if(isnum(val) || istext(val))
		return val
	else if(islist(val))
		return deep_clone_list(val)
	else if(isdatum(val))
		var/datum/casted = val
		return casted.clone()
	// unimplemented otherwise.
	return null
