//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Z-Level Management System
 *
 * All adds/removes should go through this. Directly modifying zlevel amount/whatever is forbidden.
 */

/**
 * Rebuilds multiz lookup.
 *
 * * Please specify a specific index/dir, doing this without that is extremely expensive.
 * * This proc reserves the right to eagerly rebuild something you didn't specify, but will never
 *   skip rebuilding something you did specify. As an example, telling it rebuild z-1's NORTH
 *   might result in all of z-1's lookups being updated, but NORTH will always be updated no matter
 *   what.
 *
 * @params
 * * for_index - for level index
 * * for_dir - for dir bits; this is ignored if for_index is null.
 * * for_reciprocal - do the same for the other level towards the target index; this is ignored if for_index is null
 */
/datum/controller/subsystem/mapping/proc/rebuild_multiz_lookup(for_index, for_dir, for_reciprocal)
	z_stack_dirty = TRUE

	if(!for_index)
		cached_level_up = new /list(world.maxz)
		cached_level_down = new /list(world.maxz)
		cached_level_east = new /list(world.maxz)
		cached_level_west = new /list(world.maxz)
		cached_level_north = new /list(world.maxz)
		cached_level_south = new /list(world.maxz)

	if(for_index)
		var/datum/map_level/level = ordered_levels[for_index]
		var/level_partner_index
		level_partner_index = level.get_level_in_dir(UP)?.z_index
		cached_level_up[for_index] = level_partner_index
		if(level_partner_index)
			rebuild_multiz_lookup(level_partner_index, DOWN, FALSE)
		level_partner_index = level.get_level_in_dir(DOWN)?.z_index
		cached_level_down[for_index] = level_partner_index
		if(level_partner_index)
			rebuild_multiz_lookup(level_partner_index, UP, FALSE)
		level_partner_index = level.get_level_in_dir(NORTH)?.z_index
		cached_level_north[for_index] = level_partner_index
		if(level_partner_index)
			rebuild_multiz_lookup(level_partner_index, SOUTH, FALSE)
		level_partner_index = level.get_level_in_dir(SOUTH)?.z_index
		cached_level_south[for_index] = level_partner_index
		if(level_partner_index)
			rebuild_multiz_lookup(level_partner_index, NORTH, FALSE)
		level_partner_index = level.get_level_in_dir(EAST)?.z_index
		cached_level_east[for_index] = level_partner_index
		if(level_partner_index)
			rebuild_multiz_lookup(level_partner_index, EAST, FALSE)
		level_partner_index = level.get_level_in_dir(WEST)?.z_index
		cached_level_west[for_index] = level_partner_index
		if(level_partner_index)
			rebuild_multiz_lookup(level_partner_index, WEST, FALSE)
	else
		for(var/i in 1 to world.maxz)
			var/datum/map_level/level = ordered_levels[i]
			cached_level_up[i] = level.get_level_in_dir(UP)?.z_index
			cached_level_down[i] = level.get_level_in_dir(DOWN)?.z_index
			cached_level_north[i] = level.get_level_in_dir(NORTH)?.z_index
			cached_level_south[i] = level.get_level_in_dir(SOUTH)?.z_index
			cached_level_east[i] = level.get_level_in_dir(EAST)?.z_index
			cached_level_west[i] = level.get_level_in_dir(WEST)?.z_index
			CHECK_TICK

/**
 * Performs full multiz (including turf / transition) rebuild of an active level.
 *
 * * Please specify a specific index/dir, doing this without that is extremely expensive.
 * * This proc reserves the right to eagerly rebuild something you didn't specify, but will never
 *   skip rebuilding something you did specify. As an example, telling it rebuild z-1's NORTH
 *   might result in all of z-1's lookups being updated, but NORTH will always be updated no matter
 *   what.
 *
 * @params
 * * for_index - for level index
 * * for_dir - for dir bits; this is ignored if for_index is null.
 * * for_reciprocal - do the same for the other level towards the target index; this is ignored if for_index is null
 */
/datum/controller/subsystem/mapping/proc/rebuild_multiz(for_index, for_dir, for_reciprocal)
	if(for_index)
		rebuild_multiz_lookup(for_index, for_dir, for_reciprocal)
		CHECK_TICK
		var/datum/map_level/level = ordered_levels[for_index]
		// TODO: how do we only rebuild in a specific direction?
		level.rebuild_multiz(for_reciprocal)
	else
		rebuild_multiz_lookup()
		CHECK_TICK
		for(var/i in 1 to world.maxz)
			var/datum/map_level/level = ordered_levels[for_index]
			level.rebuild_multiz()
			CHECK_TICK

//* Allocations & Deallocations * //

/**
 * allocates a raw map level using the given datum type.
 *
 * * This does not perform **any** generation or processing on the level, including replacing baseturfs!
 * * This **will** call the level's on_loaded_immediate and on_loaded_finalize.
 * * You usually want load_level() instead, this is instead the equivalent of just incrementing world.maxz.
 *
 * @params
 * * level_datum_path - a path to allocate
 *
 * @#return the instance of /datum/map_level created / used, null on failure
 */
/datum/controller/subsystem/mapping/proc/allocate_level(level_datum_path = /datum/map_level) as /datum/map_level
	RETURN_TYPE(/datum/map_level)
	UNTIL(!map_system_mutex)
	map_system_mutex = TRUE
	. = allocate_level_impl(new level_datum_path)
	map_system_mutex = FALSE

/**
 * Special internal helper. Used to allocate a level's z-index and set system variables.
 */
/datum/controller/subsystem/mapping/proc/allocate_level_impl(datum/map_level/level) as /datum/map_level
	PRIVATE_PROC(TRUE)
	RETURN_TYPE(/datum/map_level)

	// run safety checks
	ASSERT(!level.loaded)

	// register level, generating an ID if it has none
	if(level.id)
		if(!isnull(keyed_levels[level.id]))
			CRASH("ID collision on '[level.id]' during level allocation.")
	else
		do
			// TODO: persistence-stable ID
			level.id = "gen-[copytext(md5("[rand(1, 1024 ** 2)]")), 1, 5]"
		while(keyed-levels[level.id])
	keyed_levels[level.id] = level

	// allocate a zlevel
	var/allocated_z_level = allocate_z_index()
	ASSERT(allocated_z_level)
	ASSERT(isnull(ordered_levels[allocated_z_level]))

	// assign z-level
	level.z_index = allocated_z_level
	ordered_levels[allocated_z_level] = level
	. = level

	// generate names if they're not there
	if(isnull(level_or_path.display_id))
		level_or_path.display_id = generate_fluff_level_id()
	if(isnull(level_or_path.display_name))
		level_or_path.display_name = "Sector [level_or_path.display_id]"

	//! LEGACY
	if(!isnull(level.planet_path))
		SSplanets.legacy_planet_assert(z_index, level.planet_path)
	if(loaded_station)
		if((level.flags & LEGACY_LEVEL_STATION) || level.has_trait(ZTRAIT_STATION))
			loaded_station.station_levels += z_index
		if((level.flags & LEGACY_LEVEL_ADMIN) || level.has_trait(ZTRAIT_ADMIN))
			loaded_station.admin_levels += z_index
		if((level.flags & LEGACY_LEVEL_CONTACT) || level.has_trait(ZTRAIT_STATION))
			loaded_station.contact_levels += z_index
		if((level.flags & LEGACY_LEVEL_CONSOLES) || level.has_trait(ZTRAIT_STATION))
			loaded_station.map_levels += z_index
		// Holomaps
		// Auto-center the map if needed (Guess based on maxx/maxy)
		if (level.holomap_offset_x < 0)
			level.holomap_offset_x = ((HOLOMAP_ICON_SIZE - world.maxx) / 2)
		if (level.holomap_offset_x < 0)
			level.holomap_offset_y = ((HOLOMAP_ICON_SIZE - world.maxy) / 2)
		// Assign them to the map lists
		LIST_NUMERIC_SET(loaded_station.holomap_offset_x, z_index, level.holomap_offset_x)
		LIST_NUMERIC_SET(loaded_station.holomap_offset_y, z_index, level.holomap_offset_y)
		LIST_NUMERIC_SET(loaded_station.holomap_legend_x, z_index, level.holomap_legend_x)
		LIST_NUMERIC_SET(loaded_station.holomap_legend_y, z_index, level.holomap_legend_y)
	//! END

/**
 * loads a map level.
 *
 * if it doesn't have a file, we'll change all the turfs to the given baseturf and set atmos/whatever.
 *
 * @params
 * * instance - level to laod
 * * reload - reload stuff like crosslinking/verticalitty renders?
 * * center - center the level if it's mismatched sizes? we will never load a level that's too big.
 * * crop - crop the level if it's too big instead of panic
 * * deferred_callbacks - generation callbacks to defer. if this isn't provided, we fire them + finalize immediately.
 * * context - dmm_context to use
 * * defer_context - defer executing initialization/generations.
 * * orientation - load orientation override
 * * area_cache - pass in area cache for bundling to dmm_parsed.
 *
 * @return loaded context, or null on failw
 */
/datum/controller/subsystem/mapping/proc/load_level(datum/map_level/instance, rebuild, center, crop, list/deferred_callbacks, datum/dmm_context/context, defer_context, orientation, list/area_cache)
	UNTIL(!map_system_mutex)
	map_system_mutex = TRUE
	#warn impl & args
	. = load_level_impl()
	map_system_mutex = FALSE

/datum/controller/subsystem/mapping/proc/load_level_impl(datum/map_level/instance, rebuild, center, crop, list/deferred_callbacks, datum/dmm_context/context, defer_context, orientation, list/area_cache)
	PRIVATE_PROC(TRUE)

	

#warn below

/datum/controller/subsystem/mapping/proc/load_level_impl(datum/map_level/instance, rebuild, center, crop, list/deferred_callbacks, datum/dmm_context/context, defer_context, orientation, list/area_cache)

	// allocate a level for the map
	instance = allocate_level_impl(instance, FALSE)
	ASSERT(!isnull(instance))
	ASSERT(instance.id)

	// parse map
	var/map_path = instance.resolve_map_path()
	if(isfile(map_path))
	else if(!fexists(map_path))
		CRASH("fexists() failed on map path [map_path] for instance [instance] ([instance.type])")
	else
		map_path = file(map_path)
	var/datum/dmm_parsed/parsed = parse_map(map_path)

	var/real_x = 1
	var/real_y = 1
	var/real_z = instance.z_index
	var/real_orientation = orientation || instance.orientation

	// todo: check my math

	if(center)
		real_x = 1 + round((world.maxx - parsed.width) / 2)
		real_y = 1 + round((world.maxy - parsed.height) / 2)

	if(!crop && ((parsed.width + real_x - 1) > world.maxx || (parsed.height + real_y - 1) > world.maxy))
		CRASH("tried to load a map that would overrun ):")

	if(isnull(context))
		context = create_dmm_context()
	if(isnull(context.mangling_id))
		context.mangling_id = "level-[instance.mangling_id || instance.id]"
	context = parsed.load(real_x, real_y, real_z, no_changeturf = TRUE, place_on_top = FALSE, orientation = real_orientation, area_cache = area_cache, context = context)

	ASSERT(context.success)

	var/list/loaded_bounds = context.loaded_bounds
	var/list/datum/callback/generation_callbacks = list()
	instance.on_loaded_immediate(instance.z_index, generation_callbacks)

	if(!defer_context)
		context.fire_map_initializations()

	// if not group loaded, fire off hooks
	if(isnull(deferred_callbacks))
		for(var/datum/callback/cb as anything in generation_callbacks)
			cb.Invoke()

		if(initialized)
			SSatoms.init_map_bounds(loaded_bounds)

		instance.on_loaded_finalize(instance.z_index)
	else
		deferred_callbacks += generation_callbacks

	. = context

	if(rebuild)
		rebuild_verticality()
		rebuild_transitions()
		rebuild_level_multiz(list(real_z), TRUE, TRUE)

/**
 * destroys a loaded level and frees it for later usage
 *
 * @return TRUE / FALSE based on success / fail
 */
/datum/controller/subsystem/mapping/proc/unload_level(datum/map_level/instance)
	CRASH("unimplemented")

/**
 * immediately de-allocates a loaded level and frees its z-index.
 *
 * **Do not use this directly unless you absolutely know what you are doing.**
 * This does not perform any cleanup, and calling this on a loaded zlevel can have
 * severe consequences.
 *
 * @return TRUE / FALSE based on success / fail
 */
/datum/controller/subsystem/mapping/proc/unallocate_level(datum/map_level/instance)
	CRASH("unimplemented")

//* Traits, Attributes, and IDs *//

/**
 * called when a trait is added to a loaded level
 *
 * if a level is loading with traits included, this is called per trait after load.
 */
/datum/controller/subsystem/mapping/proc/on_level_trait_add(datum/map_level/level, trait)
	return

/**
 * called when a trait is removed from a loaded level
 *
 * if a level is being deleted with traits on it, this is called per trait prior to delete.
 */
/datum/controller/subsystem/mapping/proc/on_level_trait_del(datum/map_level/level, trait)
	return

/**
 * called when an attribute is set ton a level
 *
 * if a level is loading with attribute included, this is called per attribute after load with an old_value of null.
 */
/datum/controller/subsystem/mapping/proc/on_level_attribute_set(datum/map_level/level, attribute, old_value, new_value)
	return

/**
 * generates random hex fluff level id
 */
/datum/controller/subsystem/mapping/proc/generate_fluff_level_id()
	// todo: needs to be persistence-stable..?
	// todo: this looks ugly, fix it!!!
	var/discriminator = GLOB.round_id? "[num2hex(text2num(GLOB.round_id), 6)]-" : ""
	var/safety = 500
	do
		if(!--safety)
			CRASH("ran out of safety somehow, wtf")
		. = "[discriminator][num2hex(rand(1, 16 ** 4 - 1))]"
	while(. in random_fluff_level_hashes)
	random_fluff_level_hashes += .

//* Z-stacks *//

/**
 * Recalculates Z stack
 *
 * **Warning**: rebuild_verticality must be called to recalculate up/down lookups,
 * as this proc uses them for speed!
 */
/datum/controller/subsystem/mapping/proc/recalculate_z_stack()
	validate_no_loops()
	z_stack_lookup = list()
	z_stack_lookup.len = world.maxz
	var/list/left = list()
	for(var/z in 1 to world.maxz)
		left += z
	var/list/datum/map_level/bottoms = list()
	// let's sing the bottom song
	for(var/z in left)
		if(cached_level_down[z])
			continue
		bottoms += ordered_levels[z]
	for(var/datum/map_level/bottom as anything in bottoms)
		// register us
		var/list/stack = list(bottom.z_index)
		z_stack_lookup[bottom.z_index] = stack
		// let's sing the list manipulation song
		var/datum/map_level/next = ordered_levels[cached_level_up[bottom.z_index]]
		while(next)
			stack += next.z_index
			z_stack_lookup[next.z_index] = stack
			next = ordered_levels[cached_level_up[next.z_index]]

/**
 * Ensures there's no up/down infinite loops
 */
/datum/controller/subsystem/mapping/proc/validate_no_loops()
	var/list/loops = list()
	for(var/z in 1 to world.maxz)
		var/list/found
		found = list(z)
		var/next = z
		while(next)
			next = cached_level_up[next]
			if(next in found)
				loops += next
				break
			if(next)
				found += next
		next = z
		while(next)
			next = cached_level_down[next]
			if(next in found)
				loops += next
				break
			if(next)
				found += next
	if(!length(loops))
		return
	for(var/z in loops)
		var/datum/map_level/level = ordered_levels[z]
		level.link_above = null
		level.link_below = null
	stack_trace("WARNING: Up/Down loops found in zlevels [english_list(loops)]. This is not allowed and will cause both falling and zcopy to infinitely loop. All zlevels involved have been disconnected, and any structs involved have been destroyed.")
	rebuild_multiz_lookup()
