/datum/unit_test/research_design_id_collision/run()
	var/list/datum/design/designs = instantiate_all_hardcoded_designs()
	var/list/ids_seen = list()
	for(var/datum/design/D as anything in designs)
		if(ids_seen[D.id])
			Fail("Duplicate on [D.id]")
			continue
		ids_seen[D.id] = TRUE
