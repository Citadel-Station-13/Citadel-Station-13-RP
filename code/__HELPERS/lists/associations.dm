#if DM_VERSION > 513
#error Remie said that lummox was adding a way to get a lists
#error contents via list.values, if that is true remove this
#error otherwise, update the version and bug lummox
#endif
//Flattens a keyed list into a list of it's contents
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

/proc/assoc_list_strip_value_inplace(list/input)
	for(var/i in 1 to length(input))
		input[input[i]] = null
	return input

//takes an input_key, as text, and the list of keys already used, outputting a replacement key in the format of "[input_key] ([number_of_duplicates])" if it finds a duplicate
//use this for lists of things that might have the same name, like mobs or objects, that you plan on giving to a player as input
/proc/avoid_assoc_duplicate_keys(input_key, list/used_key_list)
	if(!input_key || !istype(used_key_list))
		return
	if(used_key_list[input_key])
		used_key_list[input_key]++
		input_key = "[input_key] ([used_key_list[input_key]])"
	else
		used_key_list[input_key] = 1
	return input_key