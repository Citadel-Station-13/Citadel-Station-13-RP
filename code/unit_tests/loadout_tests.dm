/datum/unit_test/loadout_test_shall_have_name_cost_path/Run()
	for(var/geartype in typesof(/datum/loadout_entry) - /datum/loadout_entry)
		var/datum/loadout_entry/G = geartype

		if(!initial(G.display_name))
			Fail("[G]: Loadout - Missing display name.")
		else if(isnull(initial(G.cost)))
			Fail("[G]: Loadout - Missing cost.")
		else if(!initial(G.path))
			Fail("[G]: Loadout - Missing path definition.")
