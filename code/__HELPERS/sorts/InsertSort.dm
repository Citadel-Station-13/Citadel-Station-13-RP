/**
 * InsertionSort
 * - Generally faster than merge for runs of 7 or smaller.
 */
/proc/insertion_sort(list/L, cmp=/proc/cmp_numeric_asc, associative, fromIndex=1, toIndex=0)
	if(L && L.len >= 2)
		fromIndex = fromIndex % L.len
		toIndex = toIndex % (L.len+1)
		if(fromIndex <= 0)
			fromIndex += L.len
		if(toIndex <= 0)
			toIndex += L.len + 1

		var/datum/sort_instance/SI = GLOB.sort_instance
		if(!SI)
			SI = new
		SI.L = L
		SI.cmp = cmp
		SI.associative = associative

		SI.binary_sort(fromIndex, toIndex, fromIndex)
	return L
