/datum/preferences/proc/spawn_checks(flags, list/errors)
	. = TRUE
	for(var/datum/category_group/player_setup_category/category in player_setup.categories)
		if(!category.spawn_checks(src, flags, errors))
			. = FALSE

// todo: at some point we should support nonhuman copy to's better.
/datum/preferences/proc/copy_to(mob/living/carbon/human/character, flags)
	// Sanitizing rather than saving as someone might still be editing when copy_to occurs.
	player_setup.sanitize_setup()

	// This needs to happen before anything else becuase it sets some variables.
	character.set_species(species)
	// Special Case: This references variables owned by two different datums, so do it here.
	if(be_random_name)
		real_name = random_name(identifying_gender,species)

	// Ask the preferences datums to apply their own settings to the new mob
	player_setup.copy_to_mob(character, flags)
	#warn this needs to prioritize entries based on load order!!
	#warn how do we carry character data through for other init like record injection?

	// Sync up all their organs and species one final time
	character.force_update_organs()
//	character.s_base = s_base //doesn't work, fuck me

	if(icon_updates)
		character.force_update_limbs()
		character.update_icons_body()
		character.update_mutations()
		character.update_underwear()
		character.update_hair()

	if(LAZYLEN(character.descriptors))
		for(var/entry in body_descriptors)
			character.descriptors[entry] = body_descriptors[entry]
