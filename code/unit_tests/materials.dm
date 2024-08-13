// checks hardcoded only (duh!!)
/datum/unit_test/materials_shall_have_ids/Run()
	var/list/ids = list()
	for(var/path in subtypesof(/datum/material))
		var/datum/material/M = path
		// for now we only check initial().
		var/id = initial(M.id)
		if(isnull(id))
			Fail("null id on [path]")
			continue
		if(ids[id])
			Fail("duplicate id [id] on [path] vs [ids[id]]")
			continue
		ids[id] = path
		M = new path
		if(M.id != initial(M.id))
			Fail("id changed on [path] after New(); this behavior will cause things to break.")
			continue
