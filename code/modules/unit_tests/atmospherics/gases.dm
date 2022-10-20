/datum/unit_test/gases_shall_be_flagged_for_core/Run()
	for(var/id in gas_data.gases)
		var/datum/gas/G = gas_data.gases[id]
		if(G.gas_group != GAS_GROUP_CORE)
			continue
		if(G.gas_flags & GAS_FLAG_CORE)
			continue
		Fail("id [id] is gas group core, but not gas flag core")
