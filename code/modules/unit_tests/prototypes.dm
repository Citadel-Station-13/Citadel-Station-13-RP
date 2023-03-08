/datum/unit_test/prototypes/Run()
	var/list/id_cache = list()
	var/list/type_cache = list()
	for(var/datum/prototype/instance as anything in subtypesof(/datum/prototype))
		if(initial(instance.abstract_type) == instance)
			continue
		// lazy is ignored
		// todo: this unit test doesn't work with anonymous ones with identifier
		// this should be fixed sometime so that identifier uniqueness is checked
		// if set, even for anonymous
		// and obviously error if not anonymous and no identifier
		instance = new instance
		type_cache[instance] = instance
		if(!instance.uid)
			Fail("[instance.type]: no uid")
		else if(id_cache[instance.uid])
			Fail("[instance.type]: collides on uid [instance.uid] with [id_cache[instance.uid]:type].")
		else
			id_cache[instance.uid] = instance

