/datum/category_group/player_setup_category/loadout_preferences
	name = "Loadout"
	sort_order = 5
	category_item_type = /datum/category_item/player_setup_item/loadout

/datum/category_group/player_setup_category/loadout_preferences/override_tab_to(mob/user)
	var/datum/category_item/player_setup_item/loadout/entry = locate() in items
	entry.ui_interact(user)
	return TRUE

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
		var/list/slot_entries = slot[LOADOUT_SLOTDATA_ENTRIES]
		for(var/id in slot_entries)
			var/datum/loadout_entry/entry = global.gear_datums[id]
			if(isnull(entry))
				slot_entries -= id
				errors?.Add("Could not find loadout entry id '[id]'")
				continue
			if(dedupe[id])
				slot_entries -= id
				errors?.Add("Fatal: Removed duplicate loadout entry for id '[id]'")
				continue
			else
				dedupe[id] = TRUE
			if(!(entry in valid_entries))
				slot_entries -= id
				errors?.Add("Not allowed to take loadout entry id '[id]")
				continue
			if(entry.cost + used_cost > total_cost)
				slot_entries -= id
				errors?.Add("Out of cost to take loadout entry '[id]'")
				continue
			else
				used_cost += entry.cost
			// commented out - /datum/loadout_entry checks this on spawn.
			/*
			var/list/entry_data = slot_entries[id]
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
	return slots

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
				errors?.Add("Insufficient loadout points for all items selected.")
			. = FALSE
		current_cost += entry.cost

/datum/category_item/player_setup_item/loadout/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["gearContext"] = tgui_loadout_context()
	var/list/allowed_ids = list()
	for(var/datum/loadout_entry/entry as anything in valid_loadout_entries(pref))
		allowed_ids += entry.legacy_get_id()
	.["gearAllowed"] = allowed_ids
	.["gearData"] = tgui_loadout_data()
	.["characterName"] = pref.real_name

/datum/category_item/player_setup_item/loadout/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CharacterLoadoutStandalone")
		ui.open()

/datum/category_item/player_setup_item/loadout/ui_status(mob/user, datum/ui_state/state, datum/tgui_module/module)
	return UI_INTERACTIVE

/datum/category_item/player_setup_item/loadout/proc/tgui_loadout_selected(list/loadout_slot)
	. = list()
	.["name"] = loadout_slot[LOADOUT_SLOTDATA_NAME]
	var/cost_used = 0
	var/cost_max = max_loadout_cost()
	var/list/our_entries = loadout_slot[LOADOUT_SLOTDATA_ENTRIES]
	var/list/entries = list()
	.["entries"] = entries
	for(var/id in our_entries)
		var/datum/loadout_entry/entry = global.gear_datums[id]
		if(isnull(entry))
			our_entries -= id
			continue
		cost_used += entry.cost
		var/list/transformed = our_entries[id]
		transformed = transformed.Copy()
		var/list/tweak_texts = list()
		for(var/datum/loadout_tweak/tweak as anything in entry.tweaks)
			tweak_texts[tweak.id] = tweak.get_contents(our_entries[id][LOADOUT_ENTRYDATA_TWEAKS]?[tweak.id] || tweak.get_default())
		transformed["tweakTexts"] = tweak_texts
		entries[entry.legacy_get_id()] = transformed
	.["costUsed"] = cost_used
	.["costMax"] = cost_max

/datum/category_item/player_setup_item/loadout/proc/tgui_loadout_data()
	. = list()
	var/list/slots = list()
	var/slot_index = pref.get_character_data(CHARACTER_DATA_LOADOUT_SLOT)
	var/list/all_slots = pref.get_character_data(CHARACTER_DATA_LOADOUT)
	for(var/i in 1 to LOADOUT_MAX_SLOTS)
		var/list/the_slot = all_slots["[i]"]
		slots[++slots.len] = list(
			"name" = the_slot?[LOADOUT_SLOTDATA_NAME] || "Slot [i]"
		)
	var/list/the_slot = all_slots["[slot_index]"]
	.["slots"] = slots
	.["slot"] = tgui_loadout_selected(the_slot)
	.["slotIndex"] = slot_index

/datum/category_item/player_setup_item/loadout/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	// todo: we really need a better way, tgui prefs when lol
	if(pref.client_ckey != usr.ckey && !check_rights(usr))
		return
	switch(action)
		if("toggle")
			var/id = params["id"]
			if(!id)
				return TRUE
			var/datum/loadout_entry/entry = global.gear_datums[id]
			if(isnull(entry))
				return TRUE
			var/list/loadout = pref.get_character_data(CHARACTER_DATA_LOADOUT)
			loadout = loadout.Copy()
			var/slot_index = pref.get_character_data(CHARACTER_DATA_LOADOUT_SLOT)
			var/list/slot = loadout["[slot_index]"]
			slot = slot?.Copy() || list()
			loadout["[slot_index]"] = slot
			var/list/entries = slot[LOADOUT_SLOTDATA_ENTRIES]
			if(isnull(entries))
				slot[LOADOUT_SLOTDATA_ENTRIES] = (entries = list())
			else
				entries = entries.Copy()
				slot[LOADOUT_SLOTDATA_ENTRIES] = entries
			if(entries[id])
				entries -= id
			else
				entries[id] = list()
			pref.set_character_data(CHARACTER_DATA_LOADOUT, loadout)
			push_loadout_data()
			pref.update_character_previews()
			return TRUE
		if("rename")
			var/id = params["id"]
			if(!id)
				return TRUE
			var/datum/loadout_entry/entry = global.gear_datums[id]
			if(isnull(entry))
				return TRUE
			var/list/loadout = pref.get_character_data(CHARACTER_DATA_LOADOUT)
			loadout = loadout.Copy()
			var/slot_index = pref.get_character_data(CHARACTER_DATA_LOADOUT_SLOT)
			var/list/slot = loadout["[slot_index]"]
			slot = slot?.Copy() || list()
			loadout["[slot_index]"] = slot
			var/list/entries = slot[LOADOUT_SLOTDATA_ENTRIES]
			var/list/entry_data = entries[id]
			if(isnull(entry_data))
				return TRUE
			entry_data = entry_data.Copy()
			entries[id] = entry_data
			if(!(entry.loadout_customize_flags & LOADOUT_CUSTOMIZE_NAME))
				return TRUE
			var/name = sanitize(params["name"], MAX_NAME_LEN)
			if(isnull(name))
				return TRUE
			if(name)
				entry_data[LOADOUT_ENTRYDATA_RENAME] = name
			else
				entry_data -= LOADOUT_ENTRYDATA_RENAME
			pref.set_character_data(CHARACTER_DATA_LOADOUT, loadout)
			push_loadout_data()
			return TRUE
		if("redesc")
			var/id = params["id"]
			if(!id)
				return TRUE
			var/datum/loadout_entry/entry = global.gear_datums[id]
			if(isnull(entry))
				return TRUE
			var/list/loadout = pref.get_character_data(CHARACTER_DATA_LOADOUT)
			loadout = loadout.Copy()
			var/slot_index = pref.get_character_data(CHARACTER_DATA_LOADOUT_SLOT)
			var/list/slot = loadout["[slot_index]"]
			slot = slot?.Copy() || list()
			loadout["[slot_index]"] = slot
			var/list/entries = slot[LOADOUT_SLOTDATA_ENTRIES]
			var/list/entry_data = entries[id]
			if(isnull(entry_data))
				return TRUE
			entry_data = entry_data.Copy()
			entries[id] = entry_data
			if(!(entry.loadout_customize_flags & LOADOUT_CUSTOMIZE_DESC))
				return TRUE
			var/desc = sanitize(params["desc"], MAX_MESSAGE_LEN)
			if(isnull(desc))
				return TRUE
			if(desc)
				entry_data[LOADOUT_ENTRYDATA_REDESC] = desc
			else
				entry_data -= LOADOUT_ENTRYDATA_REDESC
			pref.set_character_data(CHARACTER_DATA_LOADOUT, loadout)
			push_loadout_data()
			return TRUE
		if("recolor")
			var/id = params["id"]
			if(!id)
				return TRUE
			var/datum/loadout_entry/entry = global.gear_datums[id]
			if(isnull(entry))
				return TRUE
			var/list/loadout = pref.get_character_data(CHARACTER_DATA_LOADOUT)
			loadout = loadout.Copy()
			var/slot_index = pref.get_character_data(CHARACTER_DATA_LOADOUT_SLOT)
			var/list/slot = loadout["[slot_index]"]
			slot = slot?.Copy() || list()
			loadout["[slot_index]"] = slot
			var/list/entries = slot[LOADOUT_SLOTDATA_ENTRIES]
			var/list/entry_data = entries[id]
			if(isnull(entry_data))
				return TRUE
			entry_data = entry_data.Copy()
			entries[id] = entry_data
			if(!(entry.loadout_customize_flags & LOADOUT_CUSTOMIZE_COLOR))
				return TRUE
			var/color = sanitize_probably_a_byond_color(params["color"], null)
			if(!isnull(color) && (color != "#ffffff"))
				entry_data[LOADOUT_ENTRYDATA_RECOLOR] = color
			else
				entry_data -= LOADOUT_ENTRYDATA_RECOLOR
			pref.set_character_data(CHARACTER_DATA_LOADOUT, loadout)
			push_loadout_data()
			pref.update_character_previews()
			return TRUE
		if("tweak")
			var/id = params["id"]
			if(!id)
				return TRUE
			var/datum/loadout_entry/entry = global.gear_datums[id]
			if(isnull(entry))
				return TRUE
			var/list/loadout = pref.get_character_data(CHARACTER_DATA_LOADOUT)
			loadout = loadout.Copy()
			var/slot_index = pref.get_character_data(CHARACTER_DATA_LOADOUT_SLOT)
			var/list/slot = loadout["[slot_index]"]
			slot = slot?.Copy() || list()
			loadout["[slot_index]"] = slot
			var/list/entries = slot[LOADOUT_SLOTDATA_ENTRIES]
			var/list/entry_data = entries[id]
			if(isnull(entry_data))
				return TRUE
			entry_data = entry_data.Copy()
			entries[id] = entry_data
			var/list/tweak_data = entry_data[LOADOUT_ENTRYDATA_TWEAKS] || list()
			tweak_data = deep_copy_list(tweak_data)
			entry_data[LOADOUT_ENTRYDATA_TWEAKS] = tweak_data
			var/tweak_id = params["tweakId"]
			for(var/datum/loadout_tweak/tweak as anything in entry.tweaks)
				if(tweak.id != tweak_id)
					continue
				tweak_data[tweak.id] = tweak.get_metadata(usr, tweak_data[tweak.id])
				pref.set_character_data(CHARACTER_DATA_LOADOUT, loadout)
				push_loadout_data()
				pref.update_character_previews()
			return TRUE
		if("clear")
			var/list/loadout = pref.get_character_data(CHARACTER_DATA_LOADOUT)
			loadout = loadout.Copy()
			var/slot_index = pref.get_character_data(CHARACTER_DATA_LOADOUT_SLOT)
			var/wanted_index = text2num(params["index"])
			if(slot_index != wanted_index)
				return TRUE
			var/list/slot = loadout["[slot_index]"]
			slot = slot.Copy()
			loadout["[slot_index]"] = slot
			slot[LOADOUT_SLOTDATA_ENTRIES] = list()
			pref.set_character_data(CHARACTER_DATA_LOADOUT, loadout)
			push_loadout_data()
			pref.update_character_previews()
			return TRUE
		if("slot")
			var/index = text2num(params["index"])
			if(!index)
				return TRUE
			if(index > LOADOUT_MAX_SLOTS)
				return TRUE
			pref.set_character_data(CHARACTER_DATA_LOADOUT_SLOT, index)
			push_loadout_data()
			return TRUE
		if("slotName")
			var/index = text2num(params["index"])
			if(!ISINRANGE(index, 1, LOADOUT_MAX_SLOTS))
				return FALSE
			var/name = params["name"] || (input(usr, "Choose a name for Slot [index]", "Slot Rename", "Slot [index]") as text|null)
			if(isnull(name))
				return TRUE
			var/list/loadout = pref.get_character_data(CHARACTER_DATA_LOADOUT)
			loadout = loadout.Copy()
			var/slot_index = index
			var/list/slot = loadout["[slot_index]"] || list()
			slot = slot?.Copy()
			loadout["[slot_index]"] = slot
			if(name)
				slot?[LOADOUT_SLOTDATA_NAME] = name
			else
				slot?.Remove(LOADOUT_SLOTDATA_NAME)
			pref.set_character_data(CHARACTER_DATA_LOADOUT, loadout)
			push_loadout_data()
			return TRUE

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
	var/list/loadout_data = loadout_slots?["[loadout_slot]"]?[LOADOUT_SLOTDATA_ENTRIES]
	if(isnull(loadout_data))
		return
	var/max_cost = max_loadout_cost()
	var/used_cost = 0
	var/real_species_name = real_species_name()
	for(var/id in loadout_data)
		var/datum/loadout_entry/entry = gear_datums[id]
		if(!(flags & PREF_COPY_TO_LOADOUT_IGNORE_ROLE))
			if(length(entry.allowed_roles))
				if(!istype(role, /datum/role/job))
					continue
				var/datum/role/job/J = role
				if(!(J.title in entry.allowed_roles))
					continue
		if(!(flags & PREF_COPY_TO_LOADOUT_IGNORE_WHITELIST))
			if(length(entry.ckeywhitelist) && !(client_ckey in entry.ckeywhitelist))
				continue
		if(!(flags & PREF_COPY_TO_LOADOUT_IGNORE_CHECKS))
			if(entry.legacy_species_lock && (entry.legacy_species_lock != real_species_name))
				continue
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
