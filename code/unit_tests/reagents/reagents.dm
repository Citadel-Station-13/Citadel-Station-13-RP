/datum/unit_test/reagent_ids/Run()
	var/list/id_lookup = list()
	var/list/colliding = list()
	for(var/path in subtypesof(/datum/reagent))
		var/datum/reagent/R = path
		var/id = initial(R.id)
		if(id_lookup[id])
			LAZYINITLIST(colliding[id])
			colliding[id] |= id_lookup[id]
			colliding[id] |= path
			continue
		id_lookup[id] = path
	for(var/id in colliding)
		Fail("[id] collides on [english_list(colliding[id])]")
