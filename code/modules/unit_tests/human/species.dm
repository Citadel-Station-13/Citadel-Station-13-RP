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

// welcome to dealing with 18+ content
/datum/unit_test/species_age_sanity/Run()
	for(var/path in subtypesof(/datum/species))
		var/datum/species/S = path
		if(initial(S.min_age) < 18)
			Fail("[path] has min age below 18")
	for(var/path in subtypesof(/datum/character_species))
		var/datum/character_species/S = path
		if(initial(S.min_age) < 18)
			Fail("[path] has min age below 18")
