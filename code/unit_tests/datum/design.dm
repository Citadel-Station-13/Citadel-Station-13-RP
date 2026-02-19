/datum/unit_test/design_checks/Run()
	var/list/lookup = list()
	for(var/datum/prototype/design/path as anything in subtypesof(/datum/prototype/design))
		if(initial(path.abstract_type) == path)
			continue
		var/datum/prototype/design/instance = new path
		lookup[initial(path.id)] = instance
		if(!length(instance.materials_base) && !length(instance.material_costs) && !length(instance.reagents) && !length(instance.ingredients) && !(instance.design_flags & DESIGN_IGNORE_RESOURCE_SANITY))
			Fail("[instance.id] ([path]) has no material costs and is not flagged as override.")
