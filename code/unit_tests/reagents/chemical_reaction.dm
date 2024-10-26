/datum/unit_test/reagent_recipe_sanity/Run()
	var/list/seen_ids = list()
	for(var/datum/chemical_reaction/reaction as anything in SSchemistry.chemical_reactions)
		// no id collision
		if(seen_ids[reaction.id])
			TEST_FAIL("[reaction] ([reaction.type]) duplicate id on [reaction.id] against [seen_ids[reaction.id]] ([seen_ids[reaction.id]:type])")
		else
			seen_ids[reaction.id] = reaction
		// no result yet non-zero result amount
		if(!reaction.result && reaction.result_amount > 0)
			TEST_FAIL("[reaction] ([reaction.type]) has no result yet has non-zero result amount.")
		// yes result yet zero result amount
		if(reaction.result && reaction.result_amount <= 0)
			TEST_FAIL("[reaction] ([reaction.type]) has a result yet has non-positive result amount.")
		// no required reagents
		if(!length(reaction.required_reagents))
			TEST_FAIL("[reaction] ([reaction.type]) has no required reagents.")
		// sane temperatures
		if(reaction.temperature_high <= reaction.temperature_low)
			TEST_FAIL("[reaction] ([reaction.type])'s maximum temperature is lower than its minimum. What?")
		// overlap
		var/list/self_overlap_check = ((reaction.required_reagents || list()) & (reaction.catalysts || list())) & (reaction.moderators || list())
		if(length(self_overlap_check))
			TEST_FAIL("[reaction] ([reaction.type]) overlaps with itself (relevant reagents for reaction) on ids [json_encode(self_overlap_check)]")

// todo: make this actually work
/datum/unit_test/reagent_recipe_collisions/Run()
	var/list/reactions = SSchemistry.chemical_reactions.Copy()
	for(var/i in 1 to (reactions.len-1))
		var/datum/chemical_reaction/r1 = reactions[i]
		if(r1.___legacy_allow_collision_do_not_use)
			continue
		for(var/i2 in (i+1) to reactions.len)
			var/datum/chemical_reaction/r2 = reactions[i2]
			if(r2.___legacy_allow_collision_do_not_use)
				continue
			if(chem_recipes_do_conflict(r1, r2))
				Fail("Chemical recipe conflict between [r1.type] and [r2.type]")
