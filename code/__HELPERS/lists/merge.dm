/**
 * merges assoc lazylists
 *
 * input lists are unmodified and not referenced
 *
 * @return new list, null if both are null
 */
/proc/merge_lazy_assoc_list(list/A, list/B)
	if(isnull(A))
		return B?.Copy()
	else if(isnull(B))
		return A?.Copy()
	. = A.Copy()
	for(var/key in B)
		.[key] = B[key]

/**
 * merges a 2 deep assoc list
 * when conflicting, list A has priority.
 * if a key isn't a list, it'll be turned into a list when two keys exist
 *
 * originally made for dynamic tool functions
 *
 * input lists are unmodified and not re-referenced
 *
 * @return new list
 */
/proc/merge_double_lazy_assoc_list(list/A, list/B)
	. = A.Copy()
	for(var/key in B)
		if(.[key])
			if(length(.[key]))
				.[key] |= B[key]
			else if(length(B[key]))
				.[key] = B[key] | .[key]
			else
				.[key] = list(.[key], B[key])
		else
			.[key] = B[key]
