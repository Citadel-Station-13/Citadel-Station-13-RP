/datum/preferences/proc/spawn_checks(flags, list/errors, list/warnings)
	. = TRUE
	for(var/datum/category_group/player_setup_category/category in player_setup.categories)
		if(!category.spawn_checks(src, flags, errors, warnings))
			. = FALSE

// todo: at some point we should support nonhuman copy to's better.
/datum/preferences/proc/copy_to(mob/living/carbon/human/character, flags)
	// Sanitizing rather than saving as someone might still be editing when copy_to occurs.
	player_setup.sanitize_setup()
	sanitize_everything()

	// snowflake begin
	// Special Case: This references variables owned by two different datums, so do it here.
	if(be_random_name)
		real_name = random_name(identifying_gender, real_species_name())
	// snowflake end

	// Copy start
	// Gather
	// todo: cache items by load order
	var/list/datum/category_item/player_setup_item/items = list()
	for(var/datum/category_group/player_setup_category/C as anything in player_setup.categories)
		for(var/datum/category_item/player_setup_item/I as anything in C.items)
			BINARY_INSERT(I, items, /datum/category_item/player_setup_item, I, load_order, COMPARE_KEY)
	// copy to
	for(var/datum/category_item/player_setup_item/I as anything in items)
		I.copy_to_mob(src, character, I.is_global? get_global_data(I.save_key) : get_character_data(I.save_key), flags)

	// Sync up all their organs and species one final time
	character.force_update_organs()
//	character.s_base = s_base //doesn't work, fuck me

	if(!(flags & PREF_COPY_TO_DO_NOT_RENDER))
		character.force_update_limbs()
		character.update_icons_body()
		character.update_mutations()
		character.update_underwear()
		character.update_hair()

	if(LAZYLEN(character.descriptors))
		for(var/entry in body_descriptors)
			character.descriptors[entry] = body_descriptors[entry]

/**
 * /datum/mind is usually used to semantically track someone's soul
 * (this sounds stupid to say in a code comment but whatever)
 *
 * therefore if we want to get original state of a player at roundstart,
 * we're going to want to store prefs data
 *
 * pref items are able to copy_to_mob without a prefs datum to support this
 */
/datum/preferences/proc/imprint_mind(datum/mind/M)
	M.original_save_data = deep_copy_list(character)
	M.original_pref_economic_modifier = tally_background_economic_factor()
