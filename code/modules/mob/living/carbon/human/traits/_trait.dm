/datum/trait
	var/name
	var/desc = "Contact a developer if you see this trait."

	/// 0 is neutral, negative cost means negative, positive cost means positive.
	var/cost = 0
	/// A list to apply to the custom species vars.
	var/list/var_changes
	/// Store a list of paths of traits to exclude, but done automatically if they change the same vars.
	var/list/excludes
	/// A list of species that CAN take this trait, use this if only a few species can use it. -shark
	var/list/allowed_species
	/// Trait only available for custom species.
	var/custom_only = TRUE

	/// list of TRAIT_*'s to apply, using ROUNDSTART_TRAIT
	var/list/traits

/// Proc can be overridden lower to include special changes, make sure to call up though for the vars changes
/datum/trait/proc/apply(datum/species/S, mob/living/carbon/human/H)
	SHOULD_CALL_PARENT(TRUE)

	for(var/trait in traits)
		ADD_TRAIT(H, trait, ROUNDSTART_TRAIT)

	// todo: why does this depend on species? screw you, this is awful
	ASSERT(S)

	// todo: **WHY**?
	if(var_changes)
		for(var/V in var_changes)
			S.vars[V] = var_changes[V]

//Similar to the above, but for removing. Probably won't be called often/ever.
/datum/trait/proc/remove(datum/species/S)
	ASSERT(S)
	return
