/datum/unit_test/languages_shall_not_collide/Run()
	var/list/ids = list()
	var/list/names = list()
	var/list/keys = list()
	for(var/path in subtypesof(/datum/language))
		var/datum/language/L = path
		if(initial(L.abstract_type) == path)
			continue
		L = new path
		if(!L.id)
			Fail("no ID on [path]")
			continue
		if(!L.name)
			Fail("no name on [path]")
			continue
		if(ids[L.id])
			Fail("collision on id [L.id] between [path] and [ids[L.id]]")
		else
			ids[L.id] = path
		if(names[L.name])
			Fail("collision on name [L.name] between [path] and [names[L.name]]")
		else
			names[L.name] = path
		if(!L.key)	// yes empty if statement sue me
		else if(keys[L.key])
			Fail("collision on key [L.key] between [path] and [keys[L.key]]")
		else
			keys[L.key] = path
			
