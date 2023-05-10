/datum/unit_test/prototypes/Run()
	for(var/datum/controller/repository/repo_type as anything in typesof(/datum/controller/repository))
		if(initial(repo_type.abstract_type) == repo_type)
			continue
		var/list/id_cache = list()
		var/list/type_cache = list()
		for(var/datum/prototype/instance as anything in subtypesof(initial(repo_type.expected_type)))
			if(initial(instance.abstract_type) == instance)
				continue
			// lazy is ignored
			// todo: this unit test doesn't work with anonymous ones with identifier
			// this should be fixed sometime so that identifier uniqueness is checked
			// if set, even for anonymous
			// and obviously error if not anonymous and no identifier
			instance = new instance
			type_cache[instance] = instance
			if(!instance.id)
				Fail("[instance.type]: no id")
			else if(id_cache[instance.id])
				Fail("[instance.type]: collides on id [instance.id] with [id_cache[instance.id]:type].")
			else
				id_cache[instance.id] = instance

