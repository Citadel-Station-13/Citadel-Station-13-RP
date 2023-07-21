
/datum/unit_test/design_uniqueness/Run()
	var/list/lookup = list()
	for(var/datum/design/path as anything in subtypesof(/datum/design))
		if(initial(path.abstract_type) == path)
			continue
		if(!initial(path.id))
			Fail("no id on [path].")
			continue
		if(lookup[initial(path.id)])
			Fail("collision on [initial(path.id)] between [path] and [lookup[initial(path.id)]:type]")
			continue
		var/datum/design/instance = new path
		lookup[initial(path.id)] = instance
		if(!length(instance.materials) && !length(instance.material_costs) && !length(instance.reagents) && !length(instance.ingredients) && !(instance.design_flags & DESIGN_IGNORE_RESOURCE_SANITY))
			Fail("[instance.id] ([path]) has no material costs and is not flagged as override.")
