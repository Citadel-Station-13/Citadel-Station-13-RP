/datum/unit_test/map_template_paths/Run()
	for(var/path in subtypesof(/datum/map_template))
		var/datum/map_template/M = path
		if(initial(M.abstract_type) == path)
			continue
		var/map_path = initial(M.map_path)
		var/using_prefixes = FALSE
		if(isnull(map_path))
			map_path = "[initial(M.prefix)][initial(M.suffix)]"
			using_prefixes = TRUE
		if(!fexists("[map_path]"))
			var/reason = using_prefixes? "prefix+suffix ([initial(M.prefix)] / [initial(M.suffix)])" : "map_path ([initial(M.map_path)])"
			TEST_FAIL("Failed to resolve [path]'s initial [reason] to a file.")
