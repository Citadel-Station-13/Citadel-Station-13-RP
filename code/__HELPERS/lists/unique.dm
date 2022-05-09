//Return a list with no duplicate entries
/proc/uniqueList(var/list/L)
	. = list()
	for(var/i in L)
		. |= i

//same, but returns nothing and acts on list in place (also handles associated values properly)
/proc/uniqueList_inplace(list/L)
	var/temp = L.Copy()
	L.len = 0
	for(var/key in temp)
		if (isnum(key))
			L |= key
		else
			L[key] = temp[key]
	return L

// clears dupes from a list
// returns number cleared
// WARNING: EXPENSIVE, ONLY USE FOR DEBUGGING
/proc/listremovedupes_inplace(list/L)
	. = list()
	for(var/i in L)
		. |= i
	var/old = L.len
	L -= (L - .)
	return L.len - old

// counts dupes
/proc/listcountdupes(list/L)
	. = list()
	for(var/i in L)
		. |= i
	return length(L - .)
