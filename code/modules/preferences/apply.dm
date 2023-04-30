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
 * equips loadout - let SSjobs/SSticker handle this, this is for special cases.
 *
 * @params
 * * character - the mob
 * * flags - PREF_COPY_TO_ flags like in [copy_to]
 */
/datum/preferences/proc/equip_loadout(mob/character, flags)

	// todo: copypaste, refactor
	var/mob/living/carbon/human/H = character
	if(!istype(H))
		return

	//Equip custom gear loadout.
	var/list/custom_equip_slots = list()
	var/list/custom_equip_leftovers = list()
	if(gear && gear.len)
		for(var/thing in gear)
			var/datum/gear/G = gear_datums[thing]
			if(!G) //Not a real gear datum (maybe removed, as this is loaded from their savefile)
				continue

			var/permitted = TRUE

			// If they aren't, tell them
			if(!permitted)
				to_chat(H, SPAN_WARNING("Your current species, job or whitelist status does not permit you to spawn with [G.display_name]!"))
				continue

			// Implants get special treatment
			if(G.slot == "implant")
				var/obj/item/implant/I = G.spawn_item(H, gear[G.display_name])
				I.invisibility = 100
				I.implant_loadout(H)
				continue

			// Try desperately (and sorta poorly) to equip the item. Now with increased desperation!
			// why are we stuffing metadata in assoclists?
			// because client might not be valid later down, so
			// we're gonna just grab it once and call it a day
			// sigh.
			var/metadata = gear[G.name]
			if(G.slot && !(G.slot in custom_equip_slots))
				if(G.slot == SLOT_ID_MASK || G.slot == SLOT_ID_SUIT || G.slot == SLOT_ID_HEAD)
					custom_equip_leftovers[thing] = metadata
				else if(H.equip_to_slot_or_del(G.spawn_item(H, metadata), G.slot))
					to_chat(H, SPAN_NOTICE("Equipping you with \the [G.display_name]!"))
					if(G.slot != /datum/inventory_slot_meta/abstract/attach_as_accessory)
						custom_equip_slots.Add(G.slot)
				else
					custom_equip_leftovers[thing] = metadata

	// If some custom items could not be equipped before, try again now.
	for(var/thing in custom_equip_leftovers)
		var/datum/gear/G = gear_datums[thing]
		if(!(G.slot in custom_equip_slots))
			if(H.equip_to_slot_or_del(G.spawn_item(H, custom_equip_leftovers[thing]), G.slot))
				to_chat(H, "<span class='notice'>Equipping you with \the [G.display_name]!</span>")
				custom_equip_slots.Add(G.slot)
