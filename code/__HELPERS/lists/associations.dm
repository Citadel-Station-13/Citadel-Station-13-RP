#if DM_VERSION > 515
// this is just a warn now, we give up
#warn Remie said that lummox was adding a way to get a lists
#warn contents via list.values, if that is true remove this
#warn otherwise, update the version and bug lummox
#endif

/**
 * Flattens a keyed list into a list of it's contents.
 */
/proc/flatten_list_nodupe(list/key_list)
	if(!islist(key_list))
		return null
	. = list()
	for(var/key in key_list)
		. |= key_list[key]

/proc/flatten_list_inplace(list/key_list)
	for(var/i in 1 to length(key_list))
		key_list[i] = key_list[key_list[i]]
	return key_list

/proc/make_associative_inplace(list/flat_list)
	for(var/i in 1 to length(flat_list))
		flat_list[flat_list[i]] = TRUE
	return flat_list

/proc/make_associative_inplace_keep_values(list/flat_list)
	for(var/i in 1 to length(flat_list))
		if(!isnull(flat_list[flat_list[i]]))
			continue
		flat_list[flat_list[i]] = TRUE
	return flat_list

/proc/assoc_list_strip_value_inplace(list/input)
	for(var/i in 1 to length(input))
		input[input[i]] = null
	return input

/proc/deep_list2params(list/deep_list)
	var/list/L = list()
	for(var/i in deep_list)
		var/key = i
		if(isnum(key))
			L += "[key]"
			continue
		if(islist(key))
			key = deep_list2params(key)
		else if(!istext(key))
			key = "[REF(key)]"
		L += "[key]"
		var/value = deep_list[key]
		if(!isnull(value))
			if(islist(value))
				value = deep_list2params(value)
			else if(!(istext(key) || isnum(key)))
				value = "[REF(value)]"
			L["[key]"] = "[value]"
	return list2params(L)

/**
 * Takes an input_key, as text, and the list of keys already used, outputting a replacement key
 * in the format of "[input_key] ([number_of_duplicates])" if it finds a duplicate use this for
 * lists of things that might have the same name, like mobs or objects, that you plan on giving
 * to a player as input.
 */
/proc/avoid_assoc_duplicate_keys(input_key, list/used_key_list)
	if(!input_key || !istype(used_key_list))
		return
	if(used_key_list[input_key])
		used_key_list[input_key]++
		input_key = "[input_key] ([used_key_list[input_key]])"
	else
		used_key_list[input_key] = 1
	return input_key

/**
 * Return a list of the values in an assoc list (including null)
 */
/proc/list_values(list/L)
	. = list()
	for(var/e in L)
		. += L[e]
