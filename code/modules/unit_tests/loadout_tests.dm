/datum/unit_test/loadout_test_shall_have_name_cost_path

/datum/unit_test/loadout_test_shall_have_name_cost_path/Run()
	for(var/geartype in typesof(/datum/gear) - /datum/gear)
		var/datum/gear/G = geartype

		if(!initial(G.display_name))
			Fail("[G]: Loadout - Missing display name.")
		if(isnull(initial(G.cost)))
			Fail("[G]: Loadout - Missing cost.")
		if(!initial(G.path))
			Fail("[G]: Loadout - Missing path definition.")

	return TRUE
