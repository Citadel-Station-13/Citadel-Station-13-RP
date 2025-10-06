//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Z-Level Management System
 *
 * All adds/removes should go through this. Directly modifying zlevel amount/whatever is forbidden.
 */
/datum/controller/subsystem/mapping
	//* level lookups
	/// indexed level datums
	var/static/list/datum/map_level/ordered_levels = list()
	/// k-v id to level datum lookup
	var/static/list/datum/map_level/keyed_levels = list()
	/// typepath to level datum lookup
	/// we do that because we automatically generate level ids
	/// so we can't use initial(id)
	var/static/list/datum/map_level/typed_levels = list()

	//* level fluff lookups
	/// literally just a random hexadecimal store to prevent collision
	var/static/list/random_fluff_level_hashes = list()

	//* multiz core
	/// Ordered lookup list for multiz up
	var/list/cached_level_up
	/// Ordered lookup list for multiz down
	var/list/cached_level_down
	/// Ordered lookup list for east transition
	var/list/cached_level_east
	/// Ordered lookup list for west transition
	var/list/cached_level_west
	/// Ordered lookup list for north transition
	var/list/cached_level_north
	/// Ordered lookup list for south transition
	var/list/cached_level_south
	/// Z access lookup - z = list() of zlevels it can access. For performance, this is currently only including bidirectional links, AND does not support looping.
	var/list/z_stack_lookup
	/// does z stack lookup need a rebuild?
	var/z_stack_dirty = TRUE

//* Rebuilds / Caching

/datum/controller/subsystem/mapping/on_max_z_changed(old_z_count, new_z_count)
	. = ..()
	synchronize_datastructures()

/**
 * Ensure all synchronized lists are valid
 */
/datum/controller/subsystem/mapping/proc/synchronize_datastructures()
#define SYNC(var) if(!var) { var = list() ; } ; if(var.len != world.maxz) { . = TRUE ; var.len = world.maxz; }
	. = FALSE
	SYNC(cached_level_up)
	SYNC(cached_level_down)
	SYNC(cached_level_east)
	SYNC(cached_level_west)
	SYNC(cached_level_north)
	SYNC(cached_level_south)
	SYNC(z_stack_lookup)
	z_stack_dirty = FALSE
	if(.)
		z_stack_dirty = TRUE
#undef SYNC

/**
 * Call whenever a zlevel's up/down is modified
 *
 * This does NOT rebuild turf graphics - call it on each level for that.
 *
 * @params
 * * updated - the level updated, if doing a single update
 * * targeted - the new level the level is pointing to, if doing a single update
 * * dir - the direction from updated to targeted
 */
/datum/controller/subsystem/mapping/proc/rebuild_verticality(datum/map_level/updated, datum/map_level/targeted, dir)
	if(!updated || !cached_level_up || !cached_level_down)
		// full rebuild
		z_stack_dirty = TRUE
		cached_level_up = list()
		cached_level_down = list()
		cached_level_up.len = world.maxz
		cached_level_down.len = world.maxz
		for(var/i in 1 to world.maxz)
			var/datum/map_level/level = ordered_levels[i]
			cached_level_up[i] = level.level_in_dir(UP)?.z_index
			cached_level_down[i] = level.level_in_dir(DOWN)?.z_index
	else
		// smart rebuild
		ASSERT(dir)
		if(!updated.loaded)
			return
		z_stack_dirty = TRUE
		var/datum/map_level/level = updated
		switch(dir)
			if(UP)
				cached_level_up[level.z_index] = level.level_in_dir(UP)?.z_index
			if(DOWN)
				cached_level_down[level.z_index] = level.level_in_dir(DOWN)?.z_index
			else
				CRASH("Invalid dir: [dir]")

/**
 * Call whenever a zlevel's east/west/north/south is modified
 *
 * This does NOT rebuild turf graphics - call it on each level for that.
 *
 * @params
 * * updated - the level updated, if doing a single update
 * * targeted - the new level the level is pointing to, if doing a single update
 * * dir - the direction from updated to targeted
 */
/datum/controller/subsystem/mapping/proc/rebuild_transitions(datum/map_level/updated, datum/map_level/targeted, dir)
	if(!updated || !cached_level_east || !cached_level_west || !cached_level_north || !cached_level_south)
		// full rebuild
		cached_level_east = list()
		cached_level_west = list()
		cached_level_north = list()
		cached_level_south = list()
		cached_level_east.len = cached_level_west.len = cached_level_north.len = cached_level_south.len = world.maxz
		for(var/i in 1 to world.maxz)
			var/datum/map_level/level = ordered_levels[i]
			cached_level_north[i] = level.level_in_dir(NORTH)?.z_index
			cached_level_south[i] = level.level_in_dir(SOUTH)?.z_index
			cached_level_east[i] = level.level_in_dir(EAST)?.z_index
			cached_level_west[i] = level.level_in_dir(WEST)?.z_index
	else
		// smart rebuild
		if(!updated.loaded)
			return
		ASSERT(dir)
		var/datum/map_level/level = updated
		switch(dir)
			if(NORTH)
				cached_level_north[level.z_index] = level.level_in_dir(NORTH)?.z_index
			if(SOUTH)
				cached_level_south[level.z_index] = level.level_in_dir(SOUTH)?.z_index
			if(EAST)
				cached_level_east[level.z_index] = level.level_in_dir(EAST)?.z_index
			if(WEST)
				cached_level_west[level.z_index] = level.level_in_dir(WEST)?.z_index
			else
				CRASH("Invalid dir: [dir]")

/**
 * Automatically rebuilds the transitions and multiz of any zlevel that has them.
 * Usually called on world load.
 *
 * Can specify a list of zlevels to check (indices, not datums!), otherwise rebuilds all
 */
/datum/controller/subsystem/mapping/proc/rebuild_level_multiz(list/indices, turfs, transitions)
	if(!indices)
		indices = list()
		for(var/i in 1 to world.maxz)
			indices += i
	for(var/number in indices)
		var/datum/map_level/L = ordered_levels[number]
		if(transitions)
			L.rebuild_transitions()
		if(turfs)
			L.rebuild_turfs()
		CHECK_TICK

//* Allocations & Deallocations

/**
 * allocates a new map level using the given datum.
 *
 * This does not perform **any** generation or processing on the level, including replacing baseturfs!
 *
 * @params
 * * level_or_path - an instance or path to allocate
 * * rebuild - reload stuff like crosslinking/verticality renders?
 *
 * @#return the instance of /datum/map_level created / used, null on failure
 */
/datum/controller/subsystem/mapping/proc/allocate_level(datum/map_level/level_or_path = /datum/map_level, rebuild)
	RETURN_TYPE(/datum/map_level)
	UNTIL(!load_mutex)
	load_mutex = TRUE
	. = _allocate_level(arglist(args))
	load_mutex = FALSE

/datum/controller/subsystem/mapping/proc/_allocate_level(datum/map_level/level_or_path = /datum/map_level, rebuild)
	RETURN_TYPE(/datum/map_level)
	if(ispath(level_or_path))
		level_or_path = new level_or_path
	ASSERT(istype(level_or_path))
	ASSERT(!level_or_path.loaded)
	if(level_or_path.id && !isnull(keyed_levels[level_or_path.id]))
		CRASH("fatal id collision on [level_or_path.id]")

	// register level in lookup lists
	if(!level_or_path.id)
		// levels must have an ID
		do
			level_or_path.id = "gen-[copytext(md5("[rand(1, 1024 ** 2)]"), 1, 5)]"
		while(keyed_levels[level_or_path.id])
	ASSERT(!keyed_levels[level_or_path.id])
	keyed_levels[level_or_path.id] = level_or_path
	if(level_or_path.hardcoded)
		ASSERT(!typed_levels[level_or_path.type])
		typed_levels[level_or_path.type] = level_or_path

	// allocate the zlevel for the level
	var/z_index = allocate_z_index()
	ASSERT(z_index)
	var/datum/map_level/existing = ordered_levels[z_index]
	if(!isnull(existing))
		if(existing.loaded)
			ASSERT(istype(existing, /datum/map_level/unallocated))
			existing.loaded = FALSE
			existing.z_index = null

	// assign zlevel; this is now a loaded level
	level_or_path.z_index = z_index
	ordered_levels[z_index] = level_or_path
	level_or_path.loaded = TRUE
	. = level_or_path

	if(isnull(level_or_path.display_id))
		level_or_path.display_id = generate_fluff_level_id()
	if(isnull(level_or_path.display_name))
		level_or_path.display_name = "Sector [level_or_path.display_id]"

	if(rebuild)
		rebuild_verticality()
		rebuild_transitions()
		rebuild_level_multiz(list(z_index), TRUE, TRUE)

	// todo: legacy
	if(!isnull(level_or_path.planet_path))
		SSplanets.legacy_planet_assert(z_index, level_or_path.planet_path)

	//! LEGACY
	// the fact that this exists is stupid but this check
	// make sure we're not loading system maps like reserved levels before station loads.
	if(loaded_station)
		if((level_or_path.flags & LEGACY_LEVEL_STATION) || level_or_path.has_trait(ZTRAIT_STATION))
			loaded_station.station_levels += z_index
		if((level_or_path.flags & LEGACY_LEVEL_ADMIN) || level_or_path.has_trait(ZTRAIT_ADMIN))
			loaded_station.admin_levels += z_index
		if((level_or_path.flags & LEGACY_LEVEL_CONTACT) || level_or_path.has_trait(ZTRAIT_STATION))
			loaded_station.contact_levels += z_index
		if((level_or_path.flags & LEGACY_LEVEL_SEALED))
			loaded_station.sealed_levels += z_index
		if((level_or_path.flags & LEGACY_LEVEL_CONSOLES) || level_or_path.has_trait(ZTRAIT_STATION))
			loaded_station.map_levels += z_index
		// Holomaps
		// Auto-center the map if needed (Guess based on maxx/maxy)
		if (level_or_path.holomap_offset_x < 0)
			level_or_path.holomap_offset_x = ((HOLOMAP_ICON_SIZE - world.maxx) / 2)
		if (level_or_path.holomap_offset_x < 0)
			level_or_path.holomap_offset_y = ((HOLOMAP_ICON_SIZE - world.maxy) / 2)
		// Assign them to the map lists
		LIST_NUMERIC_SET(loaded_station.holomap_offset_x, z_index, level_or_path.holomap_offset_x)
		LIST_NUMERIC_SET(loaded_station.holomap_offset_y, z_index, level_or_path.holomap_offset_y)
		LIST_NUMERIC_SET(loaded_station.holomap_legend_x, z_index, level_or_path.holomap_legend_x)
		LIST_NUMERIC_SET(loaded_station.holomap_legend_y, z_index, level_or_path.holomap_legend_y)
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
	UNTIL(!load_mutex)
	load_mutex = TRUE
	. = _load_level(arglist(args))
	load_mutex = FALSE

/datum/controller/subsystem/mapping/proc/_load_level(datum/map_level/instance, rebuild, center, crop, list/deferred_callbacks, datum/dmm_context/context, defer_context, orientation, list/area_cache)
	PRIVATE_PROC(TRUE)

	// allocate a level for the map
	instance = _allocate_level(instance, FALSE)
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
/datum/controller/subsystem/mapping/proc/deallocate_level(datum/map_level/instance)
	CRASH("unimplemented")

//* Traits, Attributes, and IDs

/**
 * called when a trait is added to a loaded level
 *
 * if a level is loading with traits included, this is called per trait after load.
 */
/datum/controller/subsystem/mapping/proc/on_trait_add(datum/map_level/level, trait)
	return

/**
 * called when a trait is removed from a loaded level
 *
 * if a level is being deleted with traits on it, this is called per trait prior to delete.
 */
/datum/controller/subsystem/mapping/proc/on_trait_del(datum/map_level/level, trait)
	return

/**
 * called when an attribute is set ton a level
 *
 * if a level is loading with attribute included, this is called per attribute after load with an old_value of null.
 */
/datum/controller/subsystem/mapping/proc/on_attribute_set(datum/map_level/level, attribute, old_value, new_value)
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

//* Z stacks

/**
 * Gets the sorted Z stack list of a level - the levels accessible from a single level, in multiz
 */
/datum/controller/subsystem/mapping/proc/get_z_stack(z)
	if(z_stack_dirty)
		recalculate_z_stack()
	var/list/L = z_stack_lookup[z]
	return L.Copy()

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
		var/list/stack = list()
		do
			stack += iterating.z_index
			z_stack_lookup[iterating.z_index] = stack
			iterating = ordered_levels[cached_level_up[iterating.z_index]]
		while(iterating)
	for(var/i in 1 to world.maxz)
		if(length(z_stack_lookup[i]) >= 1)
		else
			stack_trace("z-level [i] ([ordered_levels[i]?.name]) had no z-stack. did someone mess up their up/down configs?")

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
	if(!loops.len)
		return
	for(var/z in loops)
		var/datum/map_level/level = ordered_levels[z]
		level.link_above = null
		level.link_below = null
	stack_trace("WARNING: Up/Down loops found in zlevels [english_list(loops)]. This is not allowed and will cause both falling and zcopy to infinitely loop. All zlevels involved have been disconnected, and any structs involved have been destroyed.")
	rebuild_verticality()
