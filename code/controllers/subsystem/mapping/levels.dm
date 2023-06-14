/**
 * Z-Level Management System
 *
 * All adds/removes should go through this. Directly modifying zlevel amount/whatever is forbidden.
 */
/datum/controller/subsystem/mapping
	/// indexed level datums
	var/static/list/datum/map_level/ordered_levels = list()
	/// k-v id to level datum lookup
	var/static/list/datum/map_level/keyed_levels = list()
	/// literally just a random hexadecimal store to prevent collision
	var/static/list/random_fluff_level_hashes = list()

/datum/controller/subsystem/mapping/on_max_z_changed(old_z_count, new_z_count)
	. = ..()
	// synchronize datastructures *except* for ordered_levels; allocate_z_index should be doing that.

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
	var/z_index = allocate_z_index()
	ASSERT(z_index)
	if(ispath(level_or_path))
		level_or_path = new level_or_path
	ASSERT(istype(level_or_path))
	ASSERT(!level_or_path.loaded)
	var/datum/map_level/existing = ordered_levels[z_index]
	if(!isnull(existing))
		if(existing.loaded)
			ASSERT(istype(existing, /datum/map_level/unallocated))
			existing.loaded = FALSE
	ordered_levels[z_index] = level_or_path
	level_or_path.z_index = z_index
	. = level_or_path

	if(isnull(level_or_path.display_id))
		level_or_path.display_id = generate_fluff_level_id()
	if(isnull(level_or_path.display_name))
		level_or_path.display_name = "Sector [level_or_path.display_id]"

	// todo: rebuild?
	// todo: legacy
	if(!isnull(level_or_path.planet_path))
		SSplanets.legacy_planet_assert(z_index, level_or_path.planet_path)

	//! LEGACY
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
 * * orientation - load orientation override
 * * area_cache - pass in area cache for bundling to dmm_parsed.
 *
 * @return TRUE / FALSE based on success / fail
 */
/datum/controller/subsystem/mapping/proc/load_level(datum/map_level/instance, rebuild, center, crop, list/deferred_callbacks, orientation, list/area_cache)
	instance = allocate_level(instance, FALSE)
	ASSERT(!isnull(instance))
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

	// todo: check my math

	if(center)
		real_x = 1 + round((world.maxx - parsed.width) / 2)
		real_y = 1 + round((world.maxy - parsed.height) / 2)

	if(!crop && ((parsed.width + real_x - 1) > world.maxx || (parsed.height + real_y - 1) > world.maxy))
		CRASH("tried to load a map that would overrun ):")

	parsed.load(real_x, real_y, real_z, no_changeturf = TRUE, place_on_top = FALSE, orientation = orientation || instance.orientation, area_cache = area_cache)

	var/list/datum/callback/generation_callbacks = list()
	instance.on_loaded_immediate(instance.z_index, generation_callbacks)
	// if not group loaded, fire off callbacks / finalize immediately
	if(isnull(deferred_callbacks))
		for(var/datum/callback/cb as anything in generation_callbacks)
			cb.Invoke()
		instance.on_loaded_finalize(instance.z_index)

	. = TRUE
	// todo: rebuild?

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
	var/discriminator = GLOB.round_id? "[num2hex(GLOB.round_id, 6)]-" : ""
	var/safety = 500
	do
		if(!--safety)
			CRASH("ran out of safety somehow, wtf")
		. = "[discriminator][num2hex(rand(1, 16 ** 4 - 1))]"
	while(. in random_fluff_level_hashes)
	random_fluff_level_hashes += .
