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
 * * This proc does not sleep, as it's used in some critical blocking contexts. That's why
 *   it's important to not rebuild everything unless it's actually needed, as that's very slow.
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
		if(level_partner_index && for_reciprocal)
			rebuild_multiz_lookup(level_partner_index, DOWN, FALSE)
		level_partner_index = level.get_level_in_dir(DOWN)?.z_index
		cached_level_down[for_index] = level_partner_index
		if(level_partner_index && for_reciprocal)
			rebuild_multiz_lookup(level_partner_index, UP, FALSE)
		level_partner_index = level.get_level_in_dir(NORTH)?.z_index
		cached_level_north[for_index] = level_partner_index
		if(level_partner_index && for_reciprocal)
			rebuild_multiz_lookup(level_partner_index, SOUTH, FALSE)
		level_partner_index = level.get_level_in_dir(SOUTH)?.z_index
		cached_level_south[for_index] = level_partner_index
		if(level_partner_index && for_reciprocal)
			rebuild_multiz_lookup(level_partner_index, NORTH, FALSE)
		level_partner_index = level.get_level_in_dir(EAST)?.z_index
		cached_level_east[for_index] = level_partner_index
		if(level_partner_index && for_reciprocal)
			rebuild_multiz_lookup(level_partner_index, EAST, FALSE)
		level_partner_index = level.get_level_in_dir(WEST)?.z_index
		cached_level_west[for_index] = level_partner_index
		if(level_partner_index && for_reciprocal)
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

/**
 * Performs full multiz (including turf / transition) rebuild of an active level.
 *
 * * Implies [rebuild_multiz_lookup]
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
		var/datum/map_level/level = ordered_levels[for_index]
		// TODO: how do we only rebuild in a specific direction?
		level.rebuild_multiz(for_reciprocal)
	else
		rebuild_multiz_lookup()
		spawn(0)
			for(var/i in 1 to world.maxz)
				var/datum/map_level/level = ordered_levels[for_index]
				level.rebuild_multiz()

//* Allocations & Deallocations * //

/**
 * allocates a raw map level using the given datum type.
 *
 * * This does not perform **any** generation or processing on the level, including replacing baseturfs!
 * * This **will** call the level's on_loaded_immediate and on_loaded_finalize.
 * * You usually want load_level() instead, this is instead the equivalent of just incrementing world.maxz.
 * * Any level passed in or returned from this belongs to SSmapping; you are not allowed to keep direct references to it
 *   in other datastructures.
 * * This is a very low level proc, please be careful what you do with it.
 *
 * @params
 * * level - a path, or instance.
 *
 * @#return the instance of /datum/map_level created / used, null on failure
 */
/datum/controller/subsystem/mapping/proc/allocate_level(datum/map_level/level) as /datum/map_level
	RETURN_TYPE(/datum/map_level)
	UNTIL(!map_system_mutex)
	map_system_mutex = TRUE
	. = allocate_level_impl(ispath(level) ? new level : level)
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
			level.id = "gen-[copytext(md5("[rand(1, 1024 ** 2)]"), 1, 5)]"
		while(keyed_levels[level.id])
	keyed_levels[level.id] = level

	// allocate a zlevel
	var/allocated_z_level = allocate_z_index()
	ASSERT(allocated_z_level)
	ASSERT(isnull(ordered_levels[allocated_z_level]))

	// assign z-level and set it as loaded
	level.z_index = allocated_z_level
	level.loaded = TRUE
	ordered_levels[allocated_z_level] = level
	. = level

	// generate names if they're not there
	if(isnull(level.display_id))
		level.display_id = generate_fluff_level_id()
	if(isnull(level.display_name))
		level.display_name = "Sector [level.display_id]"

	//! LEGACY
	if(!isnull(level.planet_path))
		SSplanets.legacy_planet_assert(allocated_z_level, level.planet_path)
	if(loaded_station)
		if((level.flags & LEGACY_LEVEL_STATION) || level.has_trait(ZTRAIT_STATION))
			loaded_station.station_levels += allocated_z_level
		if((level.flags & LEGACY_LEVEL_ADMIN) || level.has_trait(ZTRAIT_ADMIN))
			loaded_station.admin_levels += allocated_z_level
		if((level.flags & LEGACY_LEVEL_CONTACT) || level.has_trait(ZTRAIT_STATION))
			loaded_station.contact_levels += allocated_z_level
		if((level.flags & LEGACY_LEVEL_CONSOLES) || level.has_trait(ZTRAIT_STATION))
			loaded_station.map_levels += allocated_z_level
		// Holomaps
		// Auto-center the map if needed (Guess based on maxx/maxy)
		if (level.holomap_offset_x < 0)
			level.holomap_offset_x = ((HOLOMAP_ICON_SIZE - world.maxx) / 2)
		if (level.holomap_offset_x < 0)
			level.holomap_offset_y = ((HOLOMAP_ICON_SIZE - world.maxy) / 2)
		// Assign them to the map lists
		LIST_NUMERIC_SET(loaded_station.holomap_offset_x, allocated_z_level, level.holomap_offset_x)
		LIST_NUMERIC_SET(loaded_station.holomap_offset_y, allocated_z_level, level.holomap_offset_y)
		LIST_NUMERIC_SET(loaded_station.holomap_legend_x, allocated_z_level, level.holomap_legend_x)
		LIST_NUMERIC_SET(loaded_station.holomap_legend_y, allocated_z_level, level.holomap_legend_y)
	//! END

/**
 * loads a map level.
 *
 * if it doesn't have a file, we'll change all the turfs to the given baseturf and set atmos/whatever.
 *
 * @params
 * * instance - level to load
 * * use_area_cache - use the given list as the area cache for the DMM loader. if none is provided, one will be created.
 * * use_dmm_context - use the given dmm_context for the loader. if none is provided, one will be created.
 * * defer_for_group_load - defer things like generation callbacks. should generally only be internally used by SSmapping; the API can change at any time.
 * * out_generation_callbacks - generation callbacks emitted by on_load_immediate are put in here instead of executed, if we are deferring due to group load
 *
 * @return loaded context, or null on fail
 */
/datum/controller/subsystem/mapping/proc/load_level(
		datum/map_level/instance,
		list/use_area_cache,
		datum/dmm_context/use_dmm_context,
		defer_for_group_load,
		list/datum/callback/out_generation_callbacks,
	)
	UNTIL(!map_system_mutex)
	map_system_mutex = TRUE
	. = load_level_impl(
		instance,
		use_area_cache,
		use_dmm_context,
		defer_for_group_load,
		out_generation_callbacks,
	)
	map_system_mutex = FALSE

/datum/controller/subsystem/mapping/proc/load_level_impl(
		datum/map_level/instance,
		list/use_area_cache,
		datum/dmm_context/use_dmm_context,
		defer_for_group_load,
		list/datum/callback/out_generation_callbacks,
	)
	PRIVATE_PROC(TRUE)

	var/datum/map_level/allocated_instance = allocate_level_impl(instance, FALSE)
	ASSERT(instance.z_index)
	ASSERT(instance.id)
	ASSERT(instance == allocated_instance)

	if(isnull(use_dmm_context))
		use_dmm_context = create_dmm_context()
	if(isnull(use_dmm_context.mangling_id))
		use_dmm_context.mangling_id = "level-[instance.mangling_id || instance.id]"

	var/datum/dmm_context/loaded_context

	if(instance.base_area != world.area)
		var/area/level_area_type = instance.base_area
		var/area/level_area_instance
		if(level_area_type.unique)
			level_area_instance = GLOB.areas_by_type[level_area_type]
		if(!level_area_instance)
			level_area_instance = new(null)
		level_area_instance.take_turfs(Z_TURFS(instance.z_index))
		CHECK_TICK
	if(instance.base_turf != world.turf)
		var/list/turf/to_change = Z_TURFS(instance.z_index)
		for(var/turf/T as anything in to_change)
			T.ChangeTurf(instance.base_turf)
			CHECK_TICK

	if(instance.has_map_path())
		var/datum/dmm_parsed/parsed = instance.parse_map_path()
		if(!parsed)
			CRASH("level [instance] ([instance.type]) couldn't parse its map because its map path was missing or an unknown error occurred.")
		if(!parsed.parsed)
			CRASH("failed to parse a level being loaded. is the map malformed?")

		var/real_x = instance.load_center ? 1 + round((world.maxx - parsed.width) / 2) : 1
		var/real_y = instance.load_center ? 1 + round((world.maxy - parsed.height) / 2) : 1
		var/real_z = instance.z_index

		if(!instance.load_crop && ((parsed.width + real_x - 1) > world.maxx || (parsed.height + real_y - 1) > world.maxy))
			CRASH("tried to load a map that would overrun the world bounds")

		loaded_context = parsed.load(
			real_x,
			real_y,
			real_z,
			no_changeturf = TRUE,
			place_on_top = FALSE,
			orientation = instance.load_orientation,
			area_cache = use_area_cache,
			context = use_dmm_context,
		)

		ASSERT(loaded_context.success)
	else
		// this is not a real map path
		loaded_context = use_dmm_context
		loaded_context.mark_used()
		loaded_context.set_empty_load()
		loaded_context.success = TRUE

	// immediately update munltiz cache
	rebuild_multiz_lookup(instance.z_index)

	// fire context immediately
	loaded_context.execute_postload()

	// fire instance on load hooks
	var/list/datum/callback/generation_callbacks = list()
	instance.on_loaded_immediate(instance.z_index, generation_callbacks)

	// fire finalize and generation callbacks if not deferred
	if(!defer_for_group_load)
		for(var/datum/callback/generation_callback as anything in generation_callbacks)
			generation_callback.Invoke()
		if(!SSatoms.initialized)
			SSatoms.init_map_bounds(loaded_context.loaded_bounds)
		instance.on_loaded_finalize(instance.z_index)
		instance.rebuild_multiz()
	else
		out_generation_callbacks += generation_callbacks

	return loaded_context

/**
 * destroys a loaded level and frees it for later usage
 *
 * @return TRUE / FALSE based on success / fail
 */
/datum/controller/subsystem/mapping/proc/unload_level(datum/map_level/instance)
	if(instance.parent_map)
		CRASH("attempted to unload_level on a level with a parent map. the map must be unloaded, not the level individually.")
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
	if(instance.parent_map)
		CRASH("attempted to unallocate_level on a level with a parent map. the map must be unloaded, not the level individually.")
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
	z_stack_lookup = new /list(world.maxz)
	// let's sing the bottom song
	var/list/datum/map_level/bottoms = list()
	for(var/z in 1 to world.maxz)
		if(cached_level_down[z])
			continue
		bottoms += ordered_levels[z]
	for(var/datum/map_level/bottom as anything in bottoms)
		var/datum/map_level/iterating = bottom
		var/datum/map_level/last = null
		var/list/stack = list()
		var/list/levels_in_stack = list()
		var/discontinuity_found = FALSE
		do
			if(last && last != iterating.get_level_in_dir(DOWN))
				discontinuity_found = TRUE
			stack += iterating.z_index
			levels_in_stack += iterating.z_index
			last = iterating
			iterating = ordered_levels[cached_level_up[iterating.z_index]]
		while(iterating)
		if(discontinuity_found)
			stack_trace("z-levels [english_list(levels_in_stack)] had at least one discontinuity where going down isn't the same as going up. \
			non-euclidean verticality is not supported.")
			stack = list()
		for(var/z in levels_in_stack)
			z_stack_lookup[z] = stack
	for(var/i in 1 to world.maxz)
		if(length(z_stack_lookup[i]) >= 1)
		else
			z_stack_lookup[i] = list()
			stack_trace("z-level [i] ([ordered_levels[i]?.name]) had no z-stack. did someone mess up their up/down configs?")
	z_stack_dirty = FALSE

/**
 * Ensures there's no up/down infinite loops
 */
/datum/controller/subsystem/mapping/proc/validate_no_loops()
	var/list/loops = list()
	for(var/z in 1 to world.maxz)
		// already in a loop don't bother
		if(z in loops)
			continue
		var/list/found
		var/next
		// scan up
		next = z
		found = list(z)
		while(next)
			next = cached_level_up[next]
			if(next in found)
				loops += found
				break
			if(next)
				found += next
		// scan down
		next = z
		found = list(z)
		while(next)
			next = cached_level_down[next]
			if(next in found)
				loops += found
				break
			if(next)
				found += next
	if(!loops.len)
		return
	for(var/z in loops)
		var/datum/map_level/level = ordered_levels[z]
		level.link_above_id = null
		level.link_below_id = null
	stack_trace("WARNING: Up/Down loops found in zlevels [english_list(loops)]. This is not allowed and will cause both falling and zcopy to infinitely loop. All zlevels involved have been disconnected, and any structs involved have been destroyed.")
	rebuild_multiz_lookup()
	for(var/z in loops)
		var/datum/map_level/level = ordered_levels[z]
		if(level.link_above_id || level.link_below_id)
			stack_trace("WARNING: level [z] ([level.name]) wasn't unlinked after having a loop detected.")
			continue
		spawn(0)
			level.rebuild_multiz_vertical()
