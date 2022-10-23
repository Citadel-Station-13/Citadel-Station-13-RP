/**
 * For sorting clients or mobs by ckey.
 */
/proc/sort_key(list/ckey_list, order=1)
	return tim_sort(ckey_list, order >= 0 ? /proc/cmp_ckey_asc : /proc/cmp_ckey_dsc)

/**
 * Specifically for record datums in a list.
 */
/proc/sort_record(list/record_list, field = "name", order = 1)
	GLOB.cmp_field = field
	return tim_sort(record_list, order >= 0 ? /proc/cmp_records_asc : /proc/cmp_records_dsc)

/**
 * Sort any value in a list.
 */
/proc/sort_list(list/list_to_sort, cmp=/proc/cmp_text_asc)
	return tim_sort(list_to_sort.Copy(), cmp)

/**
 * Uses sort_list() but uses the var's name specifically.
 * This should probably be using mergeAtom() instead.
 */
/proc/sort_names(list/list_to_sort, order=1)
	return tim_sort(list_to_sort.Copy(), order >= 0 ? /proc/cmp_name_asc : /proc/cmp_name_dsc)
