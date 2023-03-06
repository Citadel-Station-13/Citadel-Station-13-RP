
/datum/unit_test/design_uniqueness/Run()
	var/list/lookup = list()
	for(var/datum/design/path as anything in subtypesof(/datum/design))
		if(initial(path.abstract_type) == path)
			continue
		if(!initial(path.identifier))
			Fail("no identifier on [path].")
			continue
		if(lookup[initial(path.identifier)])
			Fail("collision on [initial(path.identifier)] between [path] and [lookup[initial(path.identifier)]:identifier]")
			continue
		lookup[initial(path.identifier)] = path
