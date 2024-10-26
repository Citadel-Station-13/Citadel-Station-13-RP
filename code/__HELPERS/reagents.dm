/proc/chem_recipes_do_conflict(datum/chemical_reaction/r1, datum/chemical_reaction/r2)
	// we can only conflict with something that requires the same container
	if(r1.required_container_path != r2.required_container_path)
		return FALSE

	// we cannot conflict with a non-overlapping temperature range
	if(r1.temperature_low >= r2.temperature_high || r1.temperature_high <= r2.temperature_low)
		return FALSE

	// todo: legacy below

	//find the reactions with the shorter and longer required_reagents list
	var/datum/chemical_reaction/long_req
	var/datum/chemical_reaction/short_req
	if(length(r1.required_reagents) > length(r2.required_reagents))
		long_req = r1
		short_req = r2
	else if(length(r1.required_reagents) < length(r2.required_reagents))
		long_req = r2
		short_req = r1
	else
		//if they are the same length, sort instead by the length of the catalyst list
		//this is important if the required_reagents lists are the same
		if(length(r1.catalysts) > length(r2.catalysts))
			long_req = r1
			short_req = r2
		else
			long_req = r2
			short_req = r1


	//check if the shorter reaction list is a subset of the longer one
	var/list/overlap = (r1.required_reagents || list()) & (r2.required_reagents || list())
	if(overlap.len != short_req.required_reagents.len)
		//there is at least one reagent in the short list that is not in the long list, so there is no conflict
		return FALSE

	//check to see if the shorter reaction's catalyst list is also a subset of the longer reaction's catalyst list
	//if the longer reaction's catalyst list is a subset of the shorter ones, that is fine
	//if the reaction lists are the same, the short reaction will have the shorter required_catalysts list, so it will register as a conflict
	var/list/short_minus_long_catalysts = (short_req.catalysts || list()) - (long_req.catalysts || list())
	if(short_minus_long_catalysts.len)
		//there is at least one unique catalyst for the short reaction, so there is no conflict
		return FALSE

	//if we got this far, the longer reaction will be impossible to create if the shorter one is earlier in GLOB.chemical_reactions_list, and will require the reagents to be added in a particular order otherwise
	return TRUE
