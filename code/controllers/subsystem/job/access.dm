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

/datum/controller/subsystem/job/proc/init_access()
	access_datums = list()
	access_path_lookup = list()
	access_id_lookup = list()
	for(var/path in subtypesof(/datum/access))
		if(is_abstract(path))
			continue
		var/datum/access/A = new path
		access_datums += A
		access_path_lookup[A.type] = A
		access_id_lookup["[A.access_value]"] = A
	tim_sort(access_datums, /proc/cmp_auto_compare)

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
/datum/controller/subsystem/job/proc/access_datum(id_or_path)
	RETURN_TYPE(/datum/access)
	return ispath(id_or_path)? access_path_lookup[id_or_path] : access_id_lookup["[id_or_path]"]

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
