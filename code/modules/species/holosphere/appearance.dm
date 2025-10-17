#define HOLOGRAM_OTHER_ALPHA 255
#define HOLOGRAM_SHIELD_MAX_HEALTH 20

/datum/species/shapeshifter/holosphere/proc/handle_hologram_overlays(datum/source, list/overlay_args, category)
	var/is_clothing = category == CARBON_APPEARANCE_UPDATE_CLOTHING
	var/overlay_index = is_clothing ? 1 : 2
	var/overlay_object = overlay_args[overlay_index]
	var/alpha_to_use = is_clothing ? 255 : get_alpha_from_key(source, category)
	if(islist(overlay_object))
		var/list/new_list = list()
		var/list/overlay_list = overlay_object
		for(var/I in overlay_list)
			if(isnull(I))
				continue
			var/mutable_appearance/new_overlay = make_hologram_appearance(I, alpha_to_use, TRUE)
			new_list += new_overlay
		overlay_args[overlay_index] = new_list
	else
		var/mutable_appearance/new_overlay = make_hologram_appearance(overlay_object, alpha_to_use, TRUE)
		overlay_args[overlay_index] = list(new_overlay)

/datum/species/shapeshifter/holosphere/proc/give_chameleon_gear(mob/living/carbon/human/H)
	if(!istype(H))
		return
	for(var/obj/item/I in H.get_equipped_items(TRUE, FALSE))
		var/turf = get_turf(H)
		if(turf)
			I.forceMove(get_turf(H))
		else
			qdel(I)

	// give character chameleon gear
	for(var/slot in chameleon_gear)
		var/chameleon_path = chameleon_gear[slot]
		var/obj/item/chameleon_item = new chameleon_path()
		H.equip_to_slot_if_possible(chameleon_item, slot, INV_OP_SILENT | INV_OP_FLUFFLESS)
		equipped_chameleon_gear[slot] = chameleon_item

/datum/species/shapeshifter/holosphere/proc/remove_chameleon_gear()
	for(var/slot in equipped_chameleon_gear)
		var/chameleon_item = equipped_chameleon_gear[slot]
		qdel(chameleon_item)

/datum/species/shapeshifter/holosphere/proc/handle_hologram_loadout(datum/source, flags, datum/prototype/role/role, list/datum/loadout_entry/loadout)
	if(istype(source, /mob/living/carbon/human/dummy))
		return

	cached_loadout_flags = flags
	cached_loadout_role = role

	give_chameleon_gear(source)

	equip_loadout(source, loadout)

// essentially a copy of the normal loadout behaviour and we then apply it to the chameleon outfit
/datum/species/shapeshifter/holosphere/proc/equip_loadout(mob/living/carbon/human/H, list/datum/loadout_entry/loadout, ignore_unused_slots = TRUE)
	slots_used = list()
	for(var/datum/loadout_entry/entry as anything in loadout)
		var/use_slot = entry.slot
		if(isnull(use_slot))
			continue

		var/obj/item/equipped = equipped_chameleon_gear[use_slot]
		if(!equipped)
			continue

		var/list/entry_data = loadout[entry]

		var/list/tweak_assembled = list()
		for(var/datum/loadout_tweak/tweak as anything in entry.tweaks)
			var/tweak_data = entry_data[LOADOUT_ENTRYDATA_TWEAKS]?[tweak.id]
			if(isnull(tweak_data))
				continue
			entry.path = tweak.tweak_spawn_path(entry.path, tweak_data)
			tweak_assembled[tweak] = tweak_data

		for(var/datum/loadout_tweak/tweak as anything in tweak_assembled)
			tweak.tweak_item(equipped, tweak_assembled[tweak])

		equipped.disguise(entry.path, H)

		if((entry.loadout_customize_flags & LOADOUT_CUSTOMIZE_NAME) && entry_data[LOADOUT_ENTRYDATA_RENAME])
			equipped.name = entry_data[LOADOUT_ENTRYDATA_RENAME]
		if((entry.loadout_customize_flags & LOADOUT_CUSTOMIZE_DESC) && entry_data[LOADOUT_ENTRYDATA_REDESC])
			equipped.desc = entry_data[LOADOUT_ENTRYDATA_REDESC]
		if((entry.loadout_customize_flags & LOADOUT_CUSTOMIZE_COLOR) && entry_data[LOADOUT_ENTRYDATA_RECOLOR])
			equipped.color = entry_data[LOADOUT_ENTRYDATA_RECOLOR]

		equipped.update_worn_icon()
		slots_used += use_slot
		loadout -= entry

	if(!ignore_unused_slots)
		// no loadout items in that slot, hide the items icon
		for(var/slot in equipped_chameleon_gear)
			if(!(slot in slots_used))
				var/obj/item/chameleon_item = equipped_chameleon_gear[slot]
				chameleon_item.disguise_blank()
				chameleon_item.update_worn_icon()

/datum/species/shapeshifter/holosphere/handle_species_job_outfit(mob/living/carbon/human/H, datum/outfit/outfit)
	handle_specific_job_clothing(H, outfit.uniform, SLOT_ID_UNIFORM)
	handle_specific_job_clothing(H, outfit.suit, SLOT_ID_SUIT)
	handle_specific_job_clothing(H, outfit.back, SLOT_ID_BACK)
	handle_specific_job_clothing(H, outfit.belt, SLOT_ID_BELT)
	handle_specific_job_clothing(H, outfit.gloves, SLOT_ID_GLOVES)
	handle_specific_job_clothing(H, outfit.shoes, SLOT_ID_SHOES)
	handle_specific_job_clothing(H, outfit.mask, SLOT_ID_MASK)
	handle_specific_job_clothing(H, outfit.head, SLOT_ID_HEAD)
	handle_specific_job_clothing(H, outfit.glasses, SLOT_ID_GLASSES)

/datum/species/shapeshifter/holosphere/proc/handle_specific_job_clothing(mob/living/carbon/human/H, path, slot_id)
	if(isnull(path)) return
	var/obj/item/equipped = equipped_chameleon_gear[slot_id]
	if(equipped)
		equipped.disguise(path, H)
		equipped.update_worn_icon()
		slots_used += slot_id

/mob/living/carbon/human/proc/switch_loadout_holosphere()
	set name = "Switch Loadout (Holosphere)"
	set desc = "Switch your chameleon clothing to a specific loadout slot."
	set category = VERB_CATEGORY_IC

	var/datum/species/shapeshifter/holosphere/holosphere_species = species
	if(!istype(holosphere_species))
		return

	var/list/loadout_options = list()
	for(var/i in 1 to LOADOUT_MAX_SLOTS)
		loadout_options["Loadout [i]"] = i
	var/loadout_option = tgui_input_list(usr, "Choose Loadout", "Loadout", loadout_options)
	var/loadout_slot = loadout_options[loadout_option]
	var/list/datum/loadout_entry/loadout_entries = client.prefs.generate_loadout_entry_list(holosphere_species.cached_loadout_flags, holosphere_species.cached_loadout_role, loadout_slot)
	holosphere_species.equip_loadout(src, loadout_entries, FALSE)

/datum/species/shapeshifter/holosphere/proc/get_alpha_from_key(var/mob/living/carbon/human/H, var/key)
	switch(key)
		if(HUMAN_OVERLAY_BODY)
			return H.body_alpha
		if(HUMAN_OVERLAY_HAIR, HUMAN_OVERLAY_FACEHAIR)
			return H.hair_alpha
	return HOLOGRAM_OTHER_ALPHA
