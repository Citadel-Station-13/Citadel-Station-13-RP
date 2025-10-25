/**
 * merge one assoc list into another by adding the values together
 */
/proc/merge_assoc_list_add_values_inplace(list/A, list/B)
	. = A
	for(var/key in B)
		.[key] = .[key] + .[key]

/**
 * merges a 2 deep assoc list
 * when conflicting, list A has priority.
 * if a key isn't a list, it'll be turned into a list when two keys exist
 *
 * originally made for dynamic tool functions
 *
 * TODO: better name
 */
/proc/merge_double_lazy_assoc_list(list/list/A, list/list/B)
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

/**
 * merges two 2-deep lists, ergo list(key = list(values))
 * dedupes values
 *
 * ## Input
 *
 * list("A" = list("a", "b", "c"))
 * list("A" = list("d"))
 *
 * ## Output
 *
 * list("A" = list("a", "b", "c", "d"))
 */
/proc/merge_2_nested_list(list/list/A, list/list/B)
	. = list()
	for(var/k1 in A)
		if(!.[k1])
			.[k1] = list()
		.[k1] += A[k1]
	for(var/k2 in B)
		if(!.[k2])
			.[k2] = list()
		.[k2] += B[k2]
