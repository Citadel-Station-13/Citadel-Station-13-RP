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

/**
 * generates an appearance from our current looks
 */
/datum/preferences/proc/render_to_appearance(flags)
	var/mob/living/carbon/human/dummy/mannequin/renderer = generate_or_wait_for_human_dummy("prefs/render_to_appearance")
	copy_to(renderer, flags)
	if(flags & PREF_COPY_TO_UNRESTRICTED_LOADOUT)
		equip_loadout(renderer)
	renderer.compile_overlays()
	. = renderer.appearance
	unset_busy_human_dummy("prefs/render_to_appearance")

/**
 * equips loadout
 *
 * @params
 * * character - the mob
 * * flags - PREF_COPY_TO_ flags like in [copy_to]
 * * role - (optional) the /datum/role being used.
 * * allow_storage_spawn - spawn extra items in storage instead of stuffing into reject.
 * * reject - list to stuff rejected items into. if null, they're deleted.
 */
/datum/preferences/proc/equip_loadout(mob/character, flags, datum/role/role, allow_storage_spawn, list/reject)
	//! todo: copypaste, refactor
	var/mob/living/carbon/human/H = character
	if(!istype(H))
		return
	//! end

	// check allow storage spawns
	if(isnull(allow_storage_spawn))
		// by default, we only spawn stuff in backpack if they're actually spawning in.
		allow_storage_spawn = PREF_COPYING_TO_CHECK_IS_SPAWNING(flags)

	// generate gear datum + data list
	var/list/loadout = generate_loadout_entry_list(flags, role)
	// overflow list of items associated to slot IDs
	var/list/obj/item/overflow = list()

	// first pass
	for(var/datum/loadout_entry/entry as anything in loadout)
		var/list/data = loadout[entry]
		var/obj/item/instanced = entry.instantiate(entry_data = data)
		var/use_slot = entry.slot
		var/succeeded = FALSE
		switch(use_slot)
			if("implant")
				var/obj/item/implant/implant = instanced
				INVOKE_ASYNC(implant, TYPE_PROC_REF(/obj/item/implant, implant_loadout), character)
				succeeded = TRUE
			if(null)
				succeeded = FALSE
			else
				succeeded = H.equip_to_slot_if_possible(instanced, use_slot, INV_OP_SILENT | INV_OP_DISALLOW_DELAY)
		if(!succeeded)
			overflow[instanced] = use_slot
		else
			if(!(flags & PREF_COPY_TO_SILENT))
				to_chat(character, SPAN_NOTICE("Equipping you with \the [instanced]"))

	// second pass
	for(var/obj/item/instance as anything in overflow)
		var/slot = overflow[instance]
		if(isnull(slot))
			continue
		if(character.equip_to_slot_if_possible(instance, slot, INV_OP_SILENT | INV_OP_DISALLOW_DELAY))
			overflow -= instance
			if(!(flags & PREF_COPY_TO_SILENT))
				to_chat(character, SPAN_NOTICE("Equipping you with \the [instance]"))
			continue

	// storage?
	if(allow_storage_spawn)
		for(var/obj/item/instance as anything in overflow)
			if(character.force_equip_to_slot(instance, /datum/inventory_slot_meta/abstract/put_in_backpack))
				overflow -= instance
				if(!(flags & PREF_COPY_TO_SILENT))
					to_chat(character, SPAN_NOTICE("Putting \the [instance] into your backpack."))
				continue

	// failed, reject or delete
	for(var/obj/item/instance as anything in overflow)
		if(!isnull(reject))
			reject += instance
		else
			qdel(instance)

/datum/preferences/proc/overflow_loadout(mob/character, flags, list/obj/item/instances, allow_storage_spawn)
	// check allow storage spawns
	if(isnull(allow_storage_spawn))
		// by default, we only spawn stuff in backpack if they're actually spawning in.
		allow_storage_spawn = PREF_COPYING_TO_CHECK_IS_SPAWNING(flags)

	// storage?
	if(allow_storage_spawn)
		for(var/obj/item/instance as anything in instances)
			if(character.force_equip_to_slot(instance, /datum/inventory_slot_meta/abstract/put_in_backpack, INV_OP_SILENT))
				instances -= instance
				if(!(flags & PREF_COPY_TO_SILENT))
					to_chat(character, SPAN_NOTICE("Putting \the [instance] into your backpack."))
				continue

	// failed, reject or delete
	for(var/obj/item/instance as anything in instances)
		qdel(instance)
