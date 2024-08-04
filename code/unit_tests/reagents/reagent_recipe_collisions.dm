

/datum/unit_test/reagent_recipe_collisions

/datum/unit_test/reagent_recipe_collisions/Run()
	var/list/reactions = SSchemistry.chemical_reactions.Copy()
	for(var/i in 1 to (reactions.len-1))
		var/datum/chemical_reaction/r1 = reactions[i]
		//! LEGACY PATCH - we don't have abstract types / skipovers properly set up.
		if(!length(r1.required_reagents))
			continue
		//! LEGACY PATCH END
		for(var/i2 in (i+1) to reactions.len)
			var/datum/chemical_reaction/r2 = reactions[i2]
			//! LEGACY PATCH - we don't have abstract types / skipovers properly set up.
			if(!length(r2.required_reagents))
				continue
			//! LEGACY PATCH END
			if(chem_recipes_do_conflict(r1, r2))
				Fail("Chemical recipe conflict between [r1.type] and [r2.type]")
