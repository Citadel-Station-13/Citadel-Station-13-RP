/datum/unit_test/inventory_slot_meta_uniqueness/Run()
	var/list/found = list()
	for(var/path in subtypesof(/datum/inventory_slot_meta))
		var/datum/inventory_slot_meta/meta = path
		if(initial(meta.abstract_type) == path)
			continue
		if(initial(meta.allow_random_id))
			continue		// power to you i guess :/
		var/id = initial(meta.id)
		if(found[id])
			Fail("duplicate id [id] on [path]")
			continue
		found[id] = TRUE
