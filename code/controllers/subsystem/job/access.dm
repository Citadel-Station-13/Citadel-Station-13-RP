/datum/controller/subsystem/job
	/// all access datums
	var/tmp/list/datum/access/access_datums
	/// access datums by path
	var/tmp/list/access_path_lookup
	/// access datum by "[id]"
	var/tmp/list/access_id_lookup
	/// access datum by string'd region
	var/tmp/list/datum/access/access_region_lists
	/// access datum by string'd type
	var/tmp/list/datum/access/access_type_lists
	/// access datum by string'd category
	var/tmp/list/datum/access/access_category_lists

	/// cached accesses that can edit lookup by "[id]" associated to list of access ids it can edit
	var/tmp/list/cached_access_edit_lookup
	/// cached accesses that can edit
	var/tmp/list/cached_access_edit_relevant

/datum/controller/subsystem/job/proc/init_access()
	access_datums = list()
	access_path_lookup = list()
	access_id_lookup = list()

	cached_access_edit_lookup = list()
	cached_access_edit_relevant = list()

	for(var/path in subtypesof(/datum/access))
		if(is_abstract(path))
			continue
		var/datum/access/A = new path
		access_datums += A
		access_path_lookup[A.type] = A
		access_id_lookup["[A.access_value]"] = A

		if(A.is_edit_relevant())
			cached_access_edit_relevant += A.access_value

	tim_sort(access_datums, /proc/cmp_auto_compare)

// todo: register access; maybe mandate custom access to start at -1? databaes query? haha?

/**
 * get all access datums with given type bits
 *
 * @params
 * * access_type - type flags
 */
/datum/controller/subsystem/job/proc/access_datums_of_type(access_type)
	return access_type_list(access_type).Copy()

/**
 * get all access datums with given region bits
 *
 * @params
 * * access_region - region flags
 */
/datum/controller/subsystem/job/proc/access_datums_of_region(access_region)
	return access_region_list(access_region).Copy()

/**
 * get access datums of a certain category
 *
 * @params
 * * access_category - category enum
 */
/datum/controller/subsystem/job/proc/access_datums_of_category(access_category)
	return access_category_list(access_category).Copy()

/**
 * get all access ids in the game
 */
/datum/controller/subsystem/job/proc/access_ids()
	. = list()
	for(var/datum/access/A as anything in access_datums)
		. += A.access_value

/**
 * get all access ids with given type bits
 *
 * @params
 * * access_type - type flags
 */
/datum/controller/subsystem/job/proc/access_ids_of_type(access_type)
	. = list()
	for(var/datum/access/A as anything in access_type_list(access_type))
		. += A.access_value

/**
 * get all access ids with given region bits
 *
 * @params
 * * access_region - region flags
 */
/datum/controller/subsystem/job/proc/access_ids_of_region(access_region)
	. = list()
	for(var/datum/access/A as anything in access_region_list(access_region))
		. += A.access_value

/**
 * get access ids of a certain category
 *
 * @params
 * * access_category - category enum
 */
/datum/controller/subsystem/job/proc/access_ids_of_category(access_category)
	. = list()
	for(var/datum/access/A as anything in access_category_list(access_category))
		. += A.access_value

/datum/controller/subsystem/job/proc/access_type_list(access_type)
	PRIVATE_PROC(TRUE)
	RETURN_TYPE(/list)
	. = access_type_lists?["[access_type]"]
	if(isnull(.))
		var/list/generating = list()
		. = generating
		LAZYSET(access_type_lists, "[access_type]", generating)
		for(var/datum/access/A as anything in access_datums)
			if(A.access_type & access_type)
				. += A
		tim_sort(generating, /proc/cmp_auto_compare)

/datum/controller/subsystem/job/proc/access_region_list(access_region)
	PRIVATE_PROC(TRUE)
	RETURN_TYPE(/list)
	. = access_region_lists?["[access_region]"]
	if(isnull(.))
		var/list/generating = list()
		. = generating
		LAZYSET(access_region_lists, "[access_region]", generating)
		for(var/datum/access/A as anything in access_datums)
			if(A.access_region & access_region)
				. += A
		tim_sort(generating, /proc/cmp_auto_compare)

/datum/controller/subsystem/job/proc/access_category_list(access_category)
	PRIVATE_PROC(TRUE)
	RETURN_TYPE(/list)
	. = access_category_lists?["[access_category]"]
	if(isnull(.))
		var/list/generating = list()
		. = generating
		LAZYSET(access_category_lists, "[access_category]", generating)
		for(var/datum/access/A as anything in access_datums)
			if(A.access_category == access_category)
				. += A
		tim_sort(generating, /proc/cmp_auto_compare)

/**
 * looks up an access datum by id or typepath
 */
/datum/controller/subsystem/job/proc/access_lookup(id_or_path)
	RETURN_TYPE(/datum/access)
	return ispath(id_or_path)? access_path_lookup[id_or_path] : access_id_lookup["[id_or_path]"]

/**
 * lookup multiple access datums from ids
 */
/datum/controller/subsystem/job/proc/access_lookup_multiple(list/ids_or_paths)
	. = list()
	for(var/i in ids_or_paths)
		if(ispath(i))
			. += access_path_lookup[i]
		else
			. += access_id_lookup["[i]"]

/**
 * generates tgui access data usable by AccessList and anything else compliant with its interface
 */
/datum/controller/subsystem/job/proc/tgui_access_data()
	var/list/data = list()
	for(var/datum/access/A as anything in access_datums)
		data[++data.len] = list(
			"value" = A.access_value,
			"name" = A.access_name,
			"category" = A.access_category,
			"region" = A.access_region,
			"type" = A.access_type,
		)
	return data

/**
 * Return list of access ids a given access can edit
 *
 * This list is *not* mutable! Do not edit it!
 */
/datum/controller/subsystem/job/proc/editable_access_ids_by_id(id)
	if((. = cached_access_edit_lookup["[id]"]))
		return
	var/datum/access/A = access_lookup(id)
	if(!A)
		cached_access_edit_lookup["[id]"] = list()
		return
	. = list()
	// special
	for(var/datum/access/other as anything in A.access_edit_list)
		. |= initial(other.access_value)
	// categories
	for(var/cat in A.access_edit_category)
		. |= access_ids_of_category(cat)
	// types
	. |= access_ids_of_type(A.access_edit_type)
	// regions
	. |= access_ids_of_region(A.access_edit_region)
	cached_access_edit_lookup["[id]"] = .
