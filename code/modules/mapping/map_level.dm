/**
 * a struct for holding information about a zlevel
 */
/datum/map_level
	/// id - must be globally unique across all possible maps
	var/id
	/// friendly debug / code name of level
	var/name
	/// player visible id for technical displays - randomized if unset
	var/display_id
	/// player visible name for non-technical displays - randomized if unset
	var/display_name
	/// traits
	var/list/traits
	/// attributes associated key-values
	var/list/attributes
	/// absolute path from server current directory to map; overrides relative_path
	var/absolute_path
	/// relative path. useless outside of manual maploads, as we can't parse relative path from DM yet.
	var/relative_path
	/// are we loaded in
	var/tmp/loaded = FALSE
	/// linkage enum
	var/linkage = Z_LINKAGE_NORMAL
	/// transition enum
	var/transition = Z_TRANSITION_DEFAULT
	/// base turf typepath for this level
	var/base_turf = /turf/space

	#warn below

	var/flags = 0			// Bitflag of which *_levels lists this z should be put into.
	var/transit_chance = 0	// Percentile chance this z will be chosen for map-edge space transit.

// Holomaps
	var/holomap_offset_x = -1	// Number of pixels to offset the map right (for centering) for this z
	var/holomap_offset_y = -1	// Number of pixels to offset the map up (for centering) for this z
	var/holomap_legend_x = 96	// x position of the holomap legend for this z
	var/holomap_legend_y = 96	// y position of the holomap legend for this z

/datum/map_level/serialize()
	. = ..()
	.["id"] = id
	.["name"] = name
	.["display_id"] = display_id
	.["display_name"] = display_name
	.["traits"] = traits
	.["attributes"] = attributes
	// if you are reading this in the future and you serialize/deserialize a map and it doesn't load,
	// this is because absolute/relative paths don't actually... work, right now.
	.["absolute_path"] = absolute_path
	.["relative_path"] = relative_path
	// end
	.["linkage"] = linkage
	.["transition"] = transition
	.["base_turf"] = "[base_turf]"

/datum/map_level/deserialize(list/data)
	if(loaded)
		CRASH("attempted deserialize while loaded")
	. = ..()
	id = .["id"]
	name = .["name"]
	display_id = .["display_id"]
	display_name = .["display_name"]
	traits = .["traits"]
	attributes = .["attributes"]
	// if you are reading this in the future and you serialize/deserialize a map and it doesn't load,
	// this is because absolute/relative paths don't actually... work, right now.
	absolute_path = .["absolute_path"]
	relative_path = .["relative_path"]
	// end
	linkage = .["linkage"]
	transition = .["transition"]
	base_turf = text2path(.["base_turf"])

/**
 * called right after we physically load in, before init
 *
 * this is *not* called if we are created from a zlevel, say, when dynamically generating a planet.
 * this is solely for hardcoded map levels to have load behaviors.
 * undefined behavior will result if this is overridden on a level used for dynamic generation.
 *
 * @params
 * * z_index - zlevel we loaded on
 * * generation_callbacks - callbacks to add to perform post_loaded generation. this will be done in a batch before on_loaded_finalize.
 */
/datum/map_level/proc/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	return

/**
 * called in a group after all maps and dependencies load
 *
 * @params
 * * z_index - zlevel we loaded on
 */
/datum/map_level/proc/on_loaded_finalize(z_index)
	return

#warn all

// Default constructor applies itself to the pae≈rent map datum
/datum/map_level/New(var/datum/map/station/map, _z)
	if(_z)
		src.z = _z
	if(!z)
		return
	map.zlevels["[z]"] = src
	if(flags & MAP_LEVEL_STATION) map.station_levels |= z
	if(flags & MAP_LEVEL_ADMIN) map.admin_levels |= z
	if(flags & MAP_LEVEL_CONTACT) map.contact_levels |= z
	if(flags & MAP_LEVEL_PLAYER) map.player_levels |= z
	if(flags & MAP_LEVEL_SEALED) map.sealed_levels |= z
	if(flags & MAP_LEVEL_XENOARCH_EXEMPT) map.xenoarch_exempt_levels |= z
	if(flags & MAP_LEVEL_EMPTY)
		if(!map.empty_levels) map.empty_levels = list()
		map.empty_levels |= z
	if(flags & MAP_LEVEL_CONSOLES)
		if (!map.map_levels)
			map.map_levels = list()
		map.map_levels |= z
	if(base_turf)
		map.base_turf_by_z["[z]"] = base_turf
	if(transit_chance)
		map.accessible_z_levels["[z]"] = transit_chance
	// Holomaps
	// Auto-center the map if needed (Guess based on maxx/maxy)
	if (holomap_offset_x < 0)
		holomap_offset_x = ((HOLOMAP_ICON_SIZE - world.maxx) / 2)
	if (holomap_offset_x < 0)
		holomap_offset_y = ((HOLOMAP_ICON_SIZE - world.maxy) / 2)
	// Assign them to the map lists
	LIST_NUMERIC_SET(map.holomap_offset_x, z, holomap_offset_x)
	LIST_NUMERIC_SET(map.holomap_offset_y, z, holomap_offset_y)
	LIST_NUMERIC_SET(map.holomap_legend_x, z, holomap_legend_x)
	LIST_NUMERIC_SET(map.holomap_legend_y, z, holomap_legend_y)

/datum/map_level/Destroy(var/force)
	stack_trace("Attempt to delete a map_level instance [log_info_line(src)]")
	if(!force)
		return QDEL_HINT_LETMELIVE // No.
	if (GLOB.using_map.zlevels["[z]"] == src)
		GLOB.using_map.zlevels -= "[z]"
	return ..()
