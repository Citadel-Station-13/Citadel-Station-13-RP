var/list/gear_datums = list()

/proc/tgui_loadout_context()
	. = list()
	var/list/instances = list()
	var/list/categories = list()
	for(var/id in global.gear_datums)
		var/datum/loadout_entry/entry = global.gear_datums[id]
		categories[entry.sort_category] = TRUE
		var/list/instance = entry.tgui_entry_data()
		instances[instance["id"]] = instance
	var/list/flattened_categories = list()
	for(var/i in categories)
		flattened_categories += i
	.["instances"] = instances
	.["categories"] = flattened_categories

/datum/loadout_entry
	abstract_type = /datum/loadout_entry

	/// unique id - must be unique (duh)
	var/id
	/// allowed standard customizations
	var/loadout_customize_flags = LOADOUT_CUSTOMIZE_COLOR | LOADOUT_CUSTOMIZE_DESC | LOADOUT_CUSTOMIZE_NAME

	/// name used for save/load don't change this or everyone loses it
	var/name
	/// what we display our name as. feel free to change this. defaults to name.
	var/display_name
	/// Description of this gear. If left blank will default to the description of the pathed item.
	var/description
	/// Path to item.
	var/path
	/// Number of points used. Items in general cost 1 point, storage/armor/gloves/special use costs 2 points.
	var/cost = 1
	/// Slot to equip to.
	var/slot
	/// Roles that can spawn with this item.
	var/list/allowed_roles
	// todo: remove in favor of uid locks and or just a better system.
	// Term to check the whitelist for.
	var/legacy_species_lock
	var/sort_category = LOADOUT_CATEGORY_GENERAL
	/// List of datums which will alter the item after it has been spawned.
	var/list/tweaks = list()
	/// Does it go on the exploitable information list?
	var/exploitable = 0
	var/static/datum/loadout_tweak/color/gear_tweak_free_color_choice = new
	var/list/ckeywhitelist
	/// Seasonal whitelist - only create if holiday is active. NOTE: This IGNORES ALLOW_HOLIDAYS config! This is because character setup isn't subsystem-init-synced so we must init all of this dumb shit before config loads.
	var/list/holiday_whitelist

/datum/loadout_entry/New()
	if(!description)
		var/obj/O = path
		description = initial(O.desc)
	if(isnull(display_name))
		display_name = name

/**
 * remove & regex this to just directly access the `.id` variable when we have id's on every entry.
 */
/datum/loadout_entry/proc/legacy_get_id()
	return name

/**
 * encodes data for tgui/interfaces/CharacterSetup/CharacterLoadout.tsx's [LoadoutEntry] interface.
 */
/datum/loadout_entry/proc/tgui_entry_data()
	var/list/tweaks = list()
	for(var/datum/loadout_tweak/tweak as anything in src.tweaks)
		tweaks += tweak.id
	return list(
		"name" = display_name || name,
		"id" = legacy_get_id(),
		"cost" = cost,
		"category" = sort_category,
		"customize" = loadout_customize_flags,
		"desc" = description,
		"tweaks" = tweaks,
	)

/datum/loadout_entry/proc/instantiate(atom/where, list/entry_data)
	var/path = src.path
	var/list/tweak_assembled = list()
	for(var/datum/loadout_tweak/tweak as anything in tweaks)
		var/tweak_data = entry_data[LOADOUT_ENTRYDATA_TWEAKS]?[tweak.id]
		if(isnull(tweak_data))
			continue
		where = tweak.tweak_spawn_location(where, tweak_data)
		path = tweak.tweak_spawn_path(path, tweak_data)
		tweak_assembled[tweak] = tweak_data
	var/obj/item/spawned = new path(where)
	if((loadout_customize_flags & LOADOUT_CUSTOMIZE_NAME) && entry_data[LOADOUT_ENTRYDATA_RENAME])
		spawned.name = entry_data[LOADOUT_ENTRYDATA_RENAME]
	if((loadout_customize_flags & LOADOUT_CUSTOMIZE_DESC) && entry_data[LOADOUT_ENTRYDATA_REDESC])
		spawned.name = entry_data[LOADOUT_ENTRYDATA_REDESC]
	if((loadout_customize_flags & LOADOUT_CUSTOMIZE_COLOR) && entry_data[LOADOUT_ENTRYDATA_RECOLOR])
		spawned.name = entry_data[LOADOUT_ENTRYDATA_RECOLOR]
	for(var/datum/loadout_tweak/tweak as anything in tweak_assembled)
		tweak.tweak_item(spawned, tweak_assembled[tweak])

	//! legacy start
	var/mob/M = where
	if(istype(M) && exploitable)
		M.amend_exploitable(spawned)
	//! end

	return spawned

/hook/startup/proc/populate_gear_list()

	// Create a list of gear datums to sort
	for(var/geartype in typesof(/datum/loadout_entry)-/datum/loadout_entry)
		var/datum/loadout_entry/G = geartype
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
		global.gear_datums[G.legacy_get_id()] = G

	return 1
