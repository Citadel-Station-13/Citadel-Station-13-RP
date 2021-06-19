/datum/unit_test/map_template_paths/Run()
	for(var/path in subtypesof(/datum/map_template))
		if(ispath(path, /datum/map_template/submap))
			var/datum/map_template/submap/S = path
			if(!fexists(initial(S.prefix) + initial(S.suffix)))
				Fail("Failed to resolve [path]'s prefix+suffix to a file - [initial(S.prefix) + initial(S.suffix)].")
			continue
		var/datum/map_template/M = path
		if(!fexists(initial(M.mappath)))
			Fail("Failed to resolve [path]'s initial mappath to a file - [initial(M.mappath)].")
