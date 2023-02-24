/singleton/hierarchy
	var/name = "Hierarchy"
	var/hierarchy_type
	var/singleton/hierarchy/parent
	var/list/singleton/hierarchy/children

/singleton/hierarchy/New(var/full_init = TRUE)
	children = list()
	if(!full_init)
		return

	var/list/all_subtypes = list()
	all_subtypes[type] = src
	for(var/subtype in subtypesof(type))
		all_subtypes[subtype] = new subtype(FALSE)

	for(var/subtype in (all_subtypes - type))
		var/singleton/hierarchy/subtype_instance = all_subtypes[subtype]
		var/singleton/hierarchy/subtype_parent = all_subtypes[subtype_instance.parent_type]
		subtype_instance.parent = subtype_parent

		dd_insertObjectList(subtype_parent.children, subtype_instance)

/singleton/hierarchy/proc/is_category()
	return hierarchy_type == type || children.len

/singleton/hierarchy/proc/is_hidden_category()
	return hierarchy_type == type

/singleton/hierarchy/dd_SortValue()
	return name
