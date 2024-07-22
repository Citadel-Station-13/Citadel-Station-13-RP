/datum/unit_test/access_datums/Run()
	var/list/lookup_ids = list()
	for(var/path in subtypesof(/datum/access))
		var/datum/access/A = path
		if(initial(A.abstract_type) == path)
			continue
		var/id = num2text(initial(A.access_value))
		if(lookup_ids[id])
			Fail("Collission on access value [id]")
			continue
		lookup_ids[id] = A
