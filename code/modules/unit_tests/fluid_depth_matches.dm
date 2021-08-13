/datum/unit_test/fluid_depth_matches/Run()
	for(var/path in typesof(/turf))
		var/turf/T = path
		if(initial(T.fluid_depth_innate) != initial(T.fluid_depth))
			Fail("[path]'s fluid_depth wasn't the same as their fluid_depth_innate. Expected: [initial(T.fluid_depth_innate)]. Actual: [initial(T.fluid_depth)].")
