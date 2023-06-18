/datum/unit_test/map_template_paths/Run()
	for(var/path in subtypesof(/datum/map_template))
		var/datum/map_template/M = path
		if(initial(M.abstract_type) == path)
			continue
		var/path = initial(M.map_path)
		if(isnull(path))
			path = "[initial(M.prefix)][initial(M.suffix)]"
		if(!fexists("[initial(M.map_path)]"))
			TEST_FAIL("Failed to resolve [path]'s initial map_path or prefix_suffix to a file - [initial(M.map_path)] / [initial(M.prefix)]+[initial(M.suffix)].")
