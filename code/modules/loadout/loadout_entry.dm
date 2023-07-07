var/list/loadout_categories = list()
var/list/gear_datums = list()

/datum/loadout_category
	var/category = ""
	var/list/gear = list()

/datum/gear
	abstract_type = /datum/gear

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
	var/list/gear_tweaks = list()
	/// Does it go on the exploitable information list?
	var/exploitable = 0
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

#warn nuke the 3 default gear tweaks from orbit

/**
 * remove & regex this to just directly access the `.id` variable when we have id's on every entry.
 */
/datum/gear/proc/legacy_get_id()
	return name

/**
 * encodes data for tgui/interfaces/CharacterSetup/CharacterLoadout.tsx's [LoadoutEntry] interface.
 */
/datum/gear/proc/tgui_entry_data()
	return list(
		"name" = display_name || name,
		"id" = legacy_get_id(),
		"cost" = cost,
		"category" = sort_category,,
		"customize" = loadout_customize_flags,
		"desc" = description,
	)

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
