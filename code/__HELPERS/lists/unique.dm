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

/proc/unique_list_atoms_by_name(list/atom/atoms)
	. = list()
	var/list/conflicting_so_far = list()
	for(var/atom/A as anything in atoms)
		if(.[A.name])
			conflicting_so_far[A.name]++
			.["[A.name] ([conflicting_so_far[A.name]])"] = A
		else
			.[A.name] = A
