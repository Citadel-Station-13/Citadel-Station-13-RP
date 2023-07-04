
/datum/unit_test/design_uniqueness/Run()
	var/list/lookup = list()
	for(var/datum/design/path as anything in subtypesof(/datum/design))
		if(initial(path.abstract_type) == path)
			continue
		if(!initial(path.id))
			Fail("no id on [path].")
			continue
		if(lookup[initial(path.id)])
			Fail("collision on [initial(path.id)] between [path] and [lookup[initial(path.id)]]")
			continue
		lookup[initial(path.id)] = initial(path.id)
