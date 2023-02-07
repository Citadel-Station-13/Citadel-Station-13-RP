/datum/controller/subsystem/job
	/// all access datums
	var/tmp/list/datum/access/access_datums
	/// access datums by path
	var/tmp/list/access_lookup
	/// access datum by string'd region
	var/tmp/list/datum/access/access_region_lists
	/// access datum by string'd type
	var/tmp/list/datum/access/access_type_lists
	/// access datum by string'd category
	var/tmp/list/datum/access/access_category_lists

/datum/controller/subsystem/job/proc/init_access()
	access_types = list()
	for(var/path in subtypesof(/datum/access))
		if(is_abstract(path))
			continue
		var/datum/access/A = new path
		access_datums += A
		access_lookup[A.type] = A

/datum/controller/subsystem/job/proc/access_datums_of_type(access_type)

/datum/controller/subsystem/job/proc/access_datums_of_region(access_region)

/datum/controller/subsystem/job/proc/access_datums_of_category(access_category)

#warn impl all
