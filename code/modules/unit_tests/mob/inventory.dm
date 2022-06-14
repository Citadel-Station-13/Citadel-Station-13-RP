/datum/unit_test/inventory_slot_meta_uniqueness/Run()
	var/list/found = list()
	for(var/path in subtypesof(/datum/inventory_slot_meta))
		var/datum/inventory_slot_meta/meta = path
		var/id = initial(meta.id)
		if(found[id])
			Fail("duplicate id [id] on [path]")
			continue
		found[id] = TRUE
