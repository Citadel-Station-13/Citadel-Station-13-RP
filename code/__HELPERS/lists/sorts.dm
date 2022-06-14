///for sorting clients or mobs by ckey
/proc/sort_key(list/ckey_list, order=1)
	return sortTim(ckey_list, order >= 0 ? /proc/cmp_ckey_asc : /proc/cmp_ckey_dsc)

///Specifically for record datums in a list.
/proc/sort_record(list/record_list, field = "name", order = 1)
	GLOB.cmp_field = field
	return sortTim(record_list, order >= 0 ? /proc/cmp_records_asc : /proc/cmp_records_dsc)

///sort any value in a list
/proc/sort_list(list/list_to_sort, cmp=/proc/cmp_text_asc)
	return sortTim(list_to_sort.Copy(), cmp)

///uses sort_list() but uses the var's name specifically. This should probably be using mergeAtom() instead
/proc/sort_names(list/list_to_sort, order=1)
	return sortTim(list_to_sort.Copy(), order >= 0 ? /proc/cmp_name_asc : /proc/cmp_name_dsc)
