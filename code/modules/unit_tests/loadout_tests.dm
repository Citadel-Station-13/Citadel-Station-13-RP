/datum/unit_test/loadout_test_shall_have_name_cost_path/Run()
	var/list/ignorelist = list(
		/datum/loadout_entry/seasonal,
		/datum/loadout_entry/seasonal/christmas,
		/datum/loadout_entry/seasonal/halloween,
		/datum/loadout_entry/seasonal/masquarade,
		/datum/loadout_entry/seasonal/masquarade/syndicate,
		/datum/loadout_entry/seasonal/masquarade/changeling,
		/datum/loadout_entry/seasonal/masquarade/clockcult,
		/datum/loadout_entry/seasonal/masquarade/cult,
		/datum/loadout_entry/seasonal/masquarade/wizard,
		/datum/loadout_entry/seasonal/masquarade/ninja,
		/datum/loadout_entry/seasonal/masquarade/aesthetic,
		/datum/loadout_entry/seasonal/masquarade/dancer,
		/datum/loadout_entry/seasonal/masquarade/heretic
	)
	for(var/geartype in subtypesof(/datum/loadout_entry) - ignorelist)
		var/datum/loadout_entry/G = geartype

		// if(!initial(G.display_name))
		// 	TEST_FAIL("[G]: Loadout - Missing display name.")
		if(isnull(initial(G.cost)))
			TEST_FAIL("[G]: Loadout - Missing cost.")
		else if(!initial(G.path))
			TEST_FAIL("[G]: Loadout - Missing path definition.")
