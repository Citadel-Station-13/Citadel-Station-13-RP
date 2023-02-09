/datum/unit_test/prototypes/Run()
	var/list/id_cache = list()
	var/list/type_cache = list()
	for(var/datum/prototype/instance as anything in subtypesof(/datum/prototype))
		if(initial(instance.abstract_type) == instance)
			continue
		// lazy is ignored
		instance = new instance
		if(instance.anonymous && instance.identifier)
			Fail("[instance.type]: has identifier but is marked anonymous")
		type_cache[instance] = instance
		if(!instance.uid)
			Fail("[instance.type]: no uid")
		else if(id_cache[instance.uid])
			Fail("[instance.type]: collides on uid [instance.uid] with [id_cache[instance.uid]:type].")
		else
			id_cache[instance.uid] = instance

