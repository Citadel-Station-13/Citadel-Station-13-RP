// empty for now

/datum/unit_test/hardcoded_gas_sanity()
	for(var/datum/gas/path as anything in subtypesof(/datum/gas))
		if(initial(path.abstract_type) == path)
			continue
		var/groups = initial(path.gas_groups)
		var/flags = initial(path.gas_flags)
		if(groups & GAS_GROUP_CORE)
			if((flags & (GAS_FLAG_CORE | GAS_FLAG_FILTERABLE)) != (GAS_FLAG_CORE | GAS_FLAG_FILTERABLE))
				Fail("[path] didn't have either core or filterable flags even though it was a core group.")
		else if(!groups)
			Fail("[path] has no gas groups.")
		else if(!(groups & GAS_GROUPS_FILTERABLE) && !(flags & GAS_FLAG_FILTERABLE))
			Fail("[path] is not scrubbable through any means; this is bad.")
		// else if((groups & GAS_GROUP_UNKNOWN) && (flags & GAS_FLAG_FILTERABLE))
		// 	Fail("[path] is unknown/alien but filterable, why is it unknown if it is filterable?")
