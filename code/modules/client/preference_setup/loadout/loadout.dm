var/list/loadout_categories = list()
var/list/gear_datums = list()

/datum/loadout_category
	var/category = ""
	var/list/gear = list()

/datum/gear
	/// name used for save/load don't change this or everyone loses it
	var/name
	/// what we display our name as. feel free to change this. defaults to name.
	var/display_name
	var/description				  // Description of this gear. If left blank will default to the description of the pathed item.
	var/path					  // Path to item.
	var/cost = 1				  // Number of points used. Items in general cost 1 point, storage/armor/gloves/special use costs 2 points.
	var/slot					  // Slot to equip to.
	var/list/allowed_roles		  // Roles that can spawn with this item.
	var/whitelisted				  // Term to check the whitelist for..
	var/sort_category = "General"
	var/list/gear_tweaks = list() // List of datums which will alter the item after it has been spawned.
	var/exploitable = 0			  // Does it go on the exploitable information list?
	var/abstract_type = null
	var/static/datum/gear_tweak/color/gear_tweak_free_color_choice = new
	var/list/ckeywhitelist
	var/list/character_name
	/// Seasonal whitelist - only create if holiday is active. NOTE: This IGNORES ALLOW_HOLIDAYS config! This is because character setup isn't subsystem-init-synced so we must init all of this dumb shit before config loads.
	var/list/holiday_whitelist

/datum/gear/New()
	if(!description)
		var/obj/O = path
		description = initial(O.desc)
	gear_tweaks = list(gear_tweak_free_name, gear_tweak_free_desc, GLOB.gear_tweak_free_matrix_recolor)
	if(isnull(display_name))
		display_name = name

/datum/gear_data
	var/path
	var/location

/datum/gear_data/New(var/path, var/location)
	src.path = path
	src.location = location

/datum/gear/proc/spawn_item(var/location, var/metadata)
	var/datum/gear_data/gd = new(path, location)
	if(metadata)
		for(var/datum/gear_tweak/gt in gear_tweaks)
			gt.tweak_gear_data(metadata["[gt]"], gd)
	var/item = new gd.path(gd.location)
	if(metadata)
		for(var/datum/gear_tweak/gt in gear_tweaks)
			gt.tweak_item(item, metadata["[gt]"])
	var/mob/M = location
	if(istype(M) && exploitable)	// Update exploitable info records for the mob without creating a duplicate object at their feet.
		M.amend_exploitable(item)
	return item

/datum/loadout_category/New(var/cat)
	category = cat
	..()

/hook/startup/proc/populate_gear_list()

	// Create a list of gear datums to sort
	for(var/geartype in typesof(/datum/gear)-/datum/gear)
		var/datum/gear/G = geartype
		if(initial(G.abstract_type) == geartype)
			continue
		G = new geartype

		if(!G.name)
			stack_trace("Missing name on [G.type].")
			continue
		if(!isnum(G.cost))
			stack_trace("Missing cost on [G.type]")
			continue
		if(!G.path)
			stack_trace("Missing path on [G.type].")
			continue
		if(!G.sort_category)
			stack_trace("Missing sort category on [G.type].")
			continue
		if(length(G.holiday_whitelist))
			var/found = FALSE
			for(var/name in G.holiday_whitelist)
				if(name in SSevents.holidays)
					found = TRUE
					break
			if(!found)
				continue
		if(!loadout_categories[G.sort_category])
			loadout_categories[G.sort_category] = new /datum/loadout_category(G.sort_category)
		var/datum/loadout_category/LC = loadout_categories[G.sort_category]
		gear_datums[G.name] = G
		LC.gear[G.name] = gear_datums[G.name]

	loadout_categories = tim_sort(loadout_categories, /proc/cmp_text_asc)
	for(var/loadout_category in loadout_categories)
		var/datum/loadout_category/LC = loadout_categories[loadout_category]
		LC.gear = tim_sort(LC.gear, /proc/cmp_text_asc)	// DO NOT ADD A ", TRUE" TO THE END OF THIS FUCKING LINE IT'S WHAT WAS CAUSING ALPHABETIZATION TO BREAK
	return 1

/datum/category_item/player_setup_item/loadout
	name = "Loadout"
	sort_order = 1
	var/current_tab = "General"

/datum/category_item/player_setup_item/loadout/load_character(var/savefile/S)
	from_file(S["gear_list"], pref.gear_list)
	from_file(S["gear_slot"], pref.gear_slot)
	if(pref.gear_list!=null && pref.gear_slot!=null)
		pref.gear = pref.gear_list["[pref.gear_slot]"]
	else
		from_file(S["gear"], pref.gear)
		pref.gear_slot = 1

/datum/category_item/player_setup_item/loadout/save_character(var/savefile/S)
	pref.gear_list["[pref.gear_slot]"] = pref.gear
	to_file(S["gear_list"], pref.gear_list)
	to_file(S["gear_slot"], pref.gear_slot)

/datum/category_item/player_setup_item/loadout/proc/valid_gear_choices(var/max_cost)
	. = list()
	var/mob/preference_mob = preference_mob()
	var/list/whitelist_cache = list()
	for(var/gear_name in gear_datums)
		var/datum/gear/G = gear_datums[gear_name]
		if(G.whitelisted)
			var/spec = G.whitelisted
			if(whitelist_cache[spec] == null)
				whitelist_cache[spec] = is_alien_whitelisted(preference_mob, name_static_species_meta(spec))
			if(!whitelist_cache[spec])
				continue

		if(G.whitelisted && !is_alien_whitelisted(preference_mob, name_static_species_meta(G.whitelisted)))
			continue
		if(max_cost && G.cost > max_cost)
			continue
		if(preference_mob && preference_mob.client)
			if(G.ckeywhitelist && !(preference_mob.ckey in G.ckeywhitelist))
				continue
			if(G.character_name && !(preference_mob.client.prefs.real_name in G.character_name))
				continue
		. += gear_name

/datum/category_item/player_setup_item/loadout/sanitize_character()
	var/mob/preference_mob = preference_mob()
	if(!islist(pref.gear))
		pref.gear = list()
	if(!islist(pref.gear_list))
		pref.gear_list = list()

	for(var/gear_name in pref.gear)
		if(!(gear_name in gear_datums))
			pref.gear -= gear_name
	var/total_cost = 0
	for(var/gear_name in pref.gear)
		if(!gear_datums[gear_name])
			to_chat(preference_mob, SPAN_WARNING("You cannot have more than one of the \the [gear_name]"))
			pref.gear -= gear_name
		else if(!(gear_name in valid_gear_choices()))
			to_chat(preference_mob, SPAN_WARNING("You cannot take \the [gear_name] as you are not whitelisted for the species or item."))
			pref.gear -= gear_name
		else
			var/datum/gear/G = gear_datums[gear_name]
			if(total_cost + G.cost > max_gear_points())
				pref.gear -= gear_name
				to_chat(preference_mob, SPAN_WARNING("You cannot afford to take \the [gear_name]"))
			else
				total_cost += G.cost

/datum/category_item/player_setup_item/loadout/content()
	. = list()
	var/mob/preference_mob = preference_mob()
	var/total_cost = 0
	if(pref.gear && pref.gear.len)
		for(var/i = 1; i <= pref.gear.len; i++)
			var/datum/gear/G = gear_datums[pref.gear[i]]
			if(G)
				total_cost += G.cost

	var/fcolor =  "#3366CC"
	if(total_cost < max_gear_points())
		fcolor = "#E67300"

	. += "<table align = 'center' width = 100%>"
	. += "<tr><td colspan=3><center><a href='?src=\ref[src];prev_slot=1'>\<\<</a><b><font color = '[fcolor]'>\[[pref.gear_slot]\]</font> </b><a href='?src=\ref[src];next_slot=1'>\>\></a><b><font color = '[fcolor]'>[total_cost]/[max_gear_points()]</font> loadout points spent.</b> \[<a href='?src=\ref[src];clear_loadout=1'>Clear Loadout</a>\]</center></td></tr>"

	. += "<tr><td colspan=3><center><b>"
	var/firstcat = 1
	for(var/category in loadout_categories)

		if(firstcat)
			firstcat = 0
		else
			. += " |"

		var/datum/loadout_category/LC = loadout_categories[category]
		var/category_cost = 0
		for(var/gear in LC.gear)
			if(gear in pref.gear)
				var/datum/gear/G = LC.gear[gear]
				category_cost += G.cost

		if(category == current_tab)
			. += " <span class='linkOn'>[category] - [category_cost]</span> "
		else
			if(category_cost)
				. += " <a href='?src=\ref[src];select_category=[category]'><font color = '#E67300'>[category] - [category_cost]</font></a> "
			else
				. += " <a href='?src=\ref[src];select_category=[category]'>[category] - 0</a> "
	. += "</b></center></td></tr>"

	var/datum/loadout_category/LC = loadout_categories[current_tab]
	. += "<tr><td colspan=3><hr></td></tr>"
	. += "<tr><td colspan=3><b><center>[LC.category]</center></b></td></tr>"
	. += "<tr><td colspan=3><hr></td></tr>"
	for(var/gear_name in LC.gear)
		var/datum/gear/G = LC.gear[gear_name]
		if(preference_mob && preference_mob.client)
			if(G.ckeywhitelist && !(preference_mob.ckey in G.ckeywhitelist))
				continue
			if(G.character_name && !(preference_mob.client.prefs.real_name in G.character_name))
				continue
		var/ticked = (G.name in pref.gear)
		. += "<tr style='vertical-align:top;'><td width=25%><a style='white-space:normal;' [ticked ? "class='linkOn' " : ""]href='?src=\ref[src];toggle_gear=[html_encode(G.name)]'>[G.display_name]</a></td>"
		. += "<td width = 10% style='vertical-align:top'>[G.cost]</td>"
		. += "<td><font size=2><i>[G.description]</i></font></td></tr>"
		if(ticked)
			. += "<tr><td colspan=3>"
			for(var/datum/gear_tweak/tweak in G.gear_tweaks)
				. += " <a href='?src=\ref[src];gear=[G.name];tweak=\ref[tweak]'>[tweak.get_contents(get_tweak_metadata(G, tweak))]</a>"
			. += "</td></tr>"
	. += "</table>"
	. = jointext(., null)

/datum/category_item/player_setup_item/loadout/proc/get_gear_metadata(var/datum/gear/G)
	. = pref.gear[G.name]
	if(!.)
		. = list()
		pref.gear[G.name] = .

/datum/category_item/player_setup_item/loadout/proc/get_tweak_metadata(var/datum/gear/G, var/datum/gear_tweak/tweak)
	var/list/metadata = get_gear_metadata(G)
	. = metadata["[tweak]"]
	if(!.)
		. = tweak.get_default()
		metadata["[tweak]"] = .

/datum/category_item/player_setup_item/loadout/proc/set_tweak_metadata(var/datum/gear/G, var/datum/gear_tweak/tweak, var/new_metadata)
	var/list/metadata = get_gear_metadata(G)
	metadata["[tweak]"] = new_metadata

/datum/category_item/player_setup_item/loadout/OnTopic(href, href_list, user)
	if(href_list["toggle_gear"])
		var/datum/gear/TG = gear_datums[href_list["toggle_gear"]]
		if(TG?.name in pref.gear)
			pref.gear -= TG.name
		else
			var/total_cost = 0
			for(var/gear_name in pref.gear)
				var/datum/gear/G = gear_datums[gear_name]
				if(istype(G)) total_cost += G.cost
			if((total_cost+TG.cost) <= max_gear_points())
				pref.gear += TG.name
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["gear"] && href_list["tweak"])
		var/datum/gear/gear = gear_datums[href_list["gear"]]
		var/datum/gear_tweak/tweak = locate(href_list["tweak"])
		if(!tweak || !istype(gear) || !(tweak in gear.gear_tweaks))
			return TOPIC_NOACTION
		var/metadata = tweak.get_metadata(user, get_tweak_metadata(gear, tweak))
		if(!metadata || !CanUseTopic(user))
			return TOPIC_NOACTION
		set_tweak_metadata(gear, tweak, metadata)
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["next_slot"] || href_list["prev_slot"])
		// Set the current slot in the gear list to the currently selected gear
		pref.gear_list["[pref.gear_slot]"] = pref.gear
		// If we're moving up a slot..
		if(href_list["next_slot"])
			// Change the current slot number
			pref.gear_slot = pref.gear_slot+1
			if(pref.gear_slot>config_legacy.loadout_slots)
				pref.gear_slot = 1
		// If we're moving down a slot..
		else if(href_list["prev_slot"])
			// Change current slot one down
			pref.gear_slot = pref.gear_slot-1
			if(pref.gear_slot<1)
				pref.gear_slot = config_legacy.loadout_slots
		// Set the currently selected gear to whatever's in the new slot
		if(pref.gear_list["[pref.gear_slot]"])
			pref.gear = pref.gear_list["[pref.gear_slot]"]
		else
			pref.gear = list()
			pref.gear_list["[pref.gear_slot]"] = list()
		// Refresh?
		return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list["select_category"])
		current_tab = href_list["select_category"]
		return TOPIC_REFRESH
	else if(href_list["clear_loadout"])
		pref.gear.Cut()
		return TOPIC_REFRESH_UPDATE_PREVIEW
	return ..()

/proc/max_gear_points()
	. = MAX_GEAR_COST
	for(var/name in SSevents.holidays)
		var/datum/holiday/H = SSevents.holidays[name]
		if(H.loadout_spam)
			return MAX_GEAR_COST_HOLIDAY_SPAM
