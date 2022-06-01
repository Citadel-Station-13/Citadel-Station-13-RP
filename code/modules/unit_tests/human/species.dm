/datum/unit_test/species_id_sanity/Run()
	var/list/sanity_name = list()
	for(var/path in subtypesof(/datum/species))
		var/datum/species/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new S
		if(!S.name)
			Fail("[path] had no name.")
			continue
		if(sanity_name[S.name])
			Fail("Duplicate name on [S.name] - [S.type].")
			continue
		sanity_name[S.name] = S
