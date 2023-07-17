/datum/category_group/player_setup_category/loadout_preferences
	name = "Loadout"
	sort_order = 5
	category_item_type = /datum/category_item/player_setup_item/loadout

/datum/category_group/player_setup_category/loadout_preferences/override_tab_to(mob/user)
	var/datum/category_item/player_setup_item/loadout/entry = locate() in items
	entry.ui_interact(user)

/datum/category_item/player_setup_item/loadout_slot
	name = "Loadout Slot"
	save_key = CHARACTER_DATA_LOADOUT_SLOT

/datum/category_item/player_setup_item/loadout_slot/default_value(randomizing)
	return 1

/datum/category_item/player_setup_item/loadout_slot/filter_data(datum/preferences/prefs, data, list/errors)
	return sanitize_integer(data, 1, LOADOUT_MAX_SLOTS)

/datum/category_item/player_setup_item/loadout
	name = "Loadout"
	save_key = CHARACTER_DATA_LOADOUT

/datum/category_item/player_setup_item/loadout/filter_data(datum/preferences/prefs, data, list/errors)
	var/list/slots = sanitize_islist(data)
	if(length(slots) > LOADOUT_MAX_SLOTS)
		slots.len = LOADOUT_MAX_SLOTS
	var/list/datum/loadout_entry/valid_entries = valid_loadout_entries(prefs)
	var/total_cost = max_loadout_cost()
	for(var/i in 1 to LOADOUT_MAX_SLOTS)
		var/numkey = num2text(i)
		if(isnull(slots[numkey]))
			continue
		var/list/slot = (slots[numkey] = sanitize_islist(slots[numkey]))
		var/list/dedupe = list()
		if(length(slot) > LOADOUT_MAX_ITEMS)
			slot.len = LOADOUT_MAX_ITEMS
		var/used_cost = 0
		for(var/id in slot)
			var/datum/loadout_entry/entry = GLOB.gear_datums[id]
			if(isnull(entry))
				slot -= id
				errors?.Add("Could not find loadout entry id '[id]'")
				continue
			if(dedupe[id])
				slot -= id
				errors?.Add("Fatal: Removed duplicate loadout entry for id '[id]'")
				continue
			else
				dedupe[id] = TRUE
			if(!(entry in valid_entries))
				slot -= id
				errors?.Add("Not allowed to take loadout entry id '[id]")
				continue
			if(entry.cost + used_cost > total_cost)
				slot -= id
				errors?.Add("Out of cost to take loadout entry '[id]'")
				continue
			else
				used_cost += entry.cost
			// commented out - /datum/loadout_entry checks this on spawn.
			/*
			var/list/entry_data = slot[id]
			for(var/datakey in entry_data)
				switch(datakey)
					if(LOADOUT_ENTRYDATA_RECOLOR)
						if(!(entry.loadout_customize_flags & LOADOUT_CUSTOMIZE_COLOR))
							entry_data -= LOADOUT_ENTRYDATA_RECOLOR
							errors?.Add("Loadout entry id '[id]' does not allow recoloring.")
					if(LOADOUT_ENTRYDATA_RENAME)
						if(!(entry.loadout_customize_flags & LOADOUT_CUSTOMIZE_NAME))
							entry_data -= LOADOUT_ENTRYDATA_RENAME
							errors?.Add("Loadout entry id '[id]' does not allow renaming.")
					if(LOADOUT_ENTRYDATA_REDESC)
						if(!(entry.loadout_customize_flags & LOADOUT_CUSTOMIZE_DESC))
							entry_data -= LOADOUT_ENTRYDATA_REDESC
							errors?.Add("Loadout entry id '[id]' does not allow setting description.")
					else
						// else we just don't care because gear tweaks need to sanitize their own stuff.
			*/

/datum/category_item/player_setup_item/loadout/spawn_checks(datum/preferences/prefs, data, flags, list/errors, list/warnings)
	var/list/slots = sanitize_islist(data)
	var/slot_index = prefs.get_character_data(CHARACTER_DATA_LOADOUT_SLOT)
	var/list/slot = SAFEINDEXACCESS(slots, slot_index)
	if(!islist(slot))
		return TRUE
	var/max_cost = max_loadout_cost()
	var/current_cost = 0
	. = TRUE
	for(var/id in slot)
		var/datum/loadout_entry/entry = global.gear_datums[id]
		if(isnull(entry))
			errors?.Add("Could not find loadout item [id].")
			. = FALSE
		if(current_cost + entry.cost > max_cost)
			if(current_cost <= max_cost)
				// only when going over.
				erorrs?.Add("Insufficient loadout points for all items selected.")
			. = FALSE
		current_cost += entry.cost

/datum/category_item/player_setup_item/loadout/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["gearContext"] = tgui_loadout_context()
	.["gearData"] = tgui_loadout_data()
	.["characterName"] = pref.real_name

/datum/category_item/player_setup_item/loadout/proc/tgui_loadout_selected(list/loadout_slot)
	. = list()
	.["name"] = loadout_slot[LOADOUT_SLOTDATA_NAME]
	var/cost_used = 0
	var/cost_max = max_loadout_cost()
	var/list/our_entries = loadout_slot[LOADOUT_SLOTDATA_ENTRIES]
	var/list/entries = list()
	.["entries"] = entries
	.["costUsed"] = cost_used
	.["costMax"] = cost_max
	for(var/id in our_entries)
		var/datum/loadout_entry/entry = global.gear_datums[id]
		if(isnull(entry))
			our_entries -= id
			continue
		cost_used += entry.cost
		var/list/transformed = our_entries[id]
		entries[++entries.len] = transformed
		for(var/datum/loadout_tweak/tweak as anything in entry.tweaks)
			tweak_texts[id] = tweak.get_contents(our_entries[id][LOADOUT_ENTRYDATA_TWEAKS]?[tweak.id])
		var/list/tweak_texts = list()
		transformed["tweakTexts"] = tweak_texts

/datum/category_item/player_setup_item/loadout/proc/tgui_loadout_data()
	#warn impl

/datum/category_item/player_setup_item/loadout/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("toggle")
			#warn impl
		if("rename")
			#warn impl
		if("redesc")
			#warn impl
		if("recolor")
			#warn impl
		if("tweak")
			#warn impl
		if("clear")
			var/list/loadout_slot = current_loadout_slot(pref)
			loadout_slot.Cut()
			push_loadout_data()
			return TRUE
		if("slot")
			var/index = text2num(params["index"])
			if(!index)
				return
			if(index > LOADOUT_MAX_SLOTS)
				return
			pref.set_character_data(CHARACTER_DATA_LOADOUT_SLOT, index)
			var/list/loadout_slot = current_loadout_slot(pref)
			push_loadout_data()
			return TRUE
		if("slotName")
			#warn impl
	#warn impl

/datum/category_item/player_setup_item/loadout/proc/current_loadout_slot(datum/preferences/prefs)
	var/list/all_slots = prefs.get_character_data(CHARACTER_DATA_LOADOUT)
	var/index_slot = prefs.get_character_data(CHARACTER_DATA_LOADOUT_SLOT)
	return all_slots["[index_slot]"] || (all_slots["[index_slot]"] = list())

/datum/category_item/player_setup_item/loadout/proc/push_loadout_data()
	push_ui_data(
		data = list(
			"gearData" = tgui_loadout_data(),
		)
	)

/datum/category_item/player_setup_item/loadout/proc/push_character_name()
	push_ui_data(
		data = list(
			"characterName" = pref.real_name,
		)
	)

/datum/category_item/player_setup_item/loadout/load_character(savefile/S)
	// LITERALLY JUST A SHIM TO TRIGGER UI UPDATES.
	addtimer(CALLBACK(src, PROC_REF(push_loadout_data)), 0)
	addtimer(CALLBACK(src, PROC_REF(push_character_name)), 0)

// These checks should all be on /datum/loadout_entry
// However, for performance reasons, we're going to avoid doing that
// Because this is way faster than
// manually calling procs and fetching species name every time.

/datum/category_item/player_setup_item/loadout/proc/check_loadout_entry(datum/preferences/prefs, datum/loadout_entry/entry)
	if(entry.legacy_species_lock && (entry.legacy_species_lock != prefs.real_species_name()))
		return FALSE
	if(entry.ckeywhitelist && (prefs.client_ckey != entry.ckeywhitelist))
		return FALSE
	return TRUE

/datum/category_item/player_setup_item/loadout/proc/valid_loadout_entries(datum/preferences/prefs)
	RETURN_TYPE(/list)
	. = list()
	var/datum/species/real_species = prefs.real_species_datum()
	var/real_species_name = real_species.name
	for(var/entry_name in gear_datums)
		var/datum/loadout_entry/entry = gear_datums[entry_name]
		if(entry.legacy_species_lock && (entry.legacy_species_lock != real_species_name))
			continue
		if(entry.ckeywhitelist && (prefs.client_ckey != entry.ckeywhitelist))
			continue
		. += entry

/**
 * generate list of gear entry datums associated to data
 *
 * @params
 * * flags - PREF_COPY_TO flags
 * * role - the role being used for equip
 */
/datum/preferences/proc/generate_loadout_entry_list(flags, datum/role/role)
	RETURN_TYPE(/list)
	. = list()
	var/list/loadout_slots = get_character_data(CHARACTER_DATA_LOADOUT)
	var/loadout_slot = get_character_data(CHARACTER_DATA_LOADOUT_SLOT)
	var/list/loadout_data = loadout_slots?["[loadout_slot]"]
	if(isnull(loadout_data))
		return
	var/max_cost = max_loadout_cost()
	var/used_cost = 0
	for(var/id in loadout_data)
		var/datum/loadout_entry/entry = gear_datums[id]
		if(!(flags & PREF_COPY_TO_LOADOUT_IGNORE_ROLE))

		if(!(flags & PREF_COPY_TO_LOADOUT_IGNORE_WHITELIST))

		if(!(flags & PREF_COPY_TO_LOADOUT_IGNORE_CHECKS))

		#warn impl all
		if(max_cost < (used_cost + entry.cost))
			continue
		used_cost += entry.cost
		.[entry] = loadout_data[id]

/proc/max_loadout_cost()
	. = LOADOUT_MAX_COST
	for(var/name in SSevents.holidays)
		var/datum/holiday/H = SSevents.holidays[name]
		if(H.loadout_spam)
			return LOADOUT_MAX_COST_HOLIDAY_SPAM
