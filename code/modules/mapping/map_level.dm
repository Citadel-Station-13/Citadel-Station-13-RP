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
	/// our zlevel once loaded
	var/tmp/z_index
	/// are we modified from our prototype/definition?
	var/tmp/modified = FALSE
	/// linkage enum
	var/linkage = Z_LINKAGE_NORMAL
	/// transition enum
	var/transition = Z_TRANSITION_DEFAULT
	/// base turf typepath for this level
	var/base_turf = /turf/space
	/// base area typepath for this level
	var/base_area = /area/space
	/// id of north zlevel - overrides linkage if set. can be set to path, autoconverts to id on new.
	var/link_north
	/// id of south zlevel - overrides linkage if set. can be set to path, autoconverts to id on new.
	var/link_south
	/// id of west zlevel - overrides linkage if set. can be set to path, autoconverts to id on new.
	var/link_west
	/// id of east zlevel - overrides linkage if set. can be set to path, autoconverts to id on new.
	var/link_east
	/// id of below zlevel - overrides linkage if set. can be set to path, autoconverts to id on new.
	var/link_below
	/// id of above zlevel - overrides linkage if set. can be set to path, autoconverts to id on new.
	var/link_above
	/// gas string / atmosphere path / atmosphere id for indoors air
	var/air_indoors = GAS_STRING_STP
	/// gas string / atmosphere path / atmosphere id for outdoors air
	var/air_outdoors = GAS_STRING_VACUUM
	/// load orientation - overridden if loaded as part of a /datum/map
	var/orientation = SOUTH

	//* LEGACY BELOW *//

	var/flags = 0			// Bitflag of which *_levels lists this z should be put into.
	//! legacy: what planet to make/use
	var/planet_path

	// Holomaps
	var/holomap_offset_x = -1	// Number of pixels to offset the map right (for centering) for this z
	var/holomap_offset_y = -1	// Number of pixels to offset the map up (for centering) for this z
	var/holomap_legend_x = 96	// x position of the holomap legend for this z
	var/holomap_legend_y = 96	// y position of the holomap legend for this z

/datum/map_level/New()
	#define UNPACK_LINK(vname) if(ispath(vname, /datum/map_level)) { var/datum/map_level/cast_##vname = vname; vname = initial(cast_##vname.id) ; }
	UNPACK_LINK(link_north)
	UNPACK_LINK(link_south)
	UNPACK_LINK(link_east)
	UNPACK_LINK(link_west)
	UNPACK_LINK(link_below)
	UNPACK_LINK(link_above)
	BLOCK_BYOND_BUG_2072419
	#undef UNPACK_LINK
	if(ispath(air_indoors, /datum/atmosphere))
		var/datum/atmosphere/cast_air_indoors = air_indoors
		air_indoors = initial(cast_air_indoors.id)
	if(ispath(air_outdoors, /datum/atmosphere))
		var/datum/atmosphere/cast_air_outdoors = air_outdoors
		air_outdoors = initial(cast_air_outdoors.id)

/datum/map_level/Destroy()
	if(loaded)
		. = QDEL_HINT_LETMELIVE
		CRASH("UH OH, SOMETHING TRIED TO DELETE AN INSTANTIATED LEVEL.")
	return ..()

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
	.["link_north"] = link_north
	.["link_south"] = link_south
	.["link_west"] = link_west
	.["link_east"] = link_east
	.["link_above"] = link_above
	.["link_below"] = link_below
	.["air_indoors"] = air_indoors
	.["air_outdoors"] = air_outdoors
	.["orientation"] = orientation

/datum/map_level/deserialize(list/data)
	if(loaded)
		CRASH("attempted deserialize while loaded")
	. = ..()
	if(!isnull(data["id"]))
		id = data["id"]
	if(!isnull(data["name"]))
		name = data["name"]
	if(!isnull(data["display_id"]))
		display_id = data["display_id"]
	if(!isnull(data["display_name"]))
		display_name = data["display_name"]
	if(!isnull(data["traits"]))
		traits = data["traits"]
	if(!isnull(data["attributes"]))
		attributes = data["attributes"]
	// if you are reading this in the future and you serialize/deserialize a map and it doesn't load,
	// this is because absolute/relative paths don't actually... work, right now.
	if(!isnull(data["absolute_path"]))
		absolute_path = data["absolute_path"]
	if(!isnull(data["relative_path"]))
		relative_path = data["relative_path"]
	// end
	if(!isnull(data["linkage"]))
		linkage = data["linkage"]
	if(!isnull(data["transition"]))
		transition = data["transition"]
	if(!isnull(data["base_turf"]))
		base_turf = text2path(data["base_turf"])
	if(!isnull(data["link_north"]))
		link_north = data["link_north"]
	if(!isnull(data["link_south"]))
		link_south = data["link_south"]
	if(!isnull(data["link_above"]))
		link_above = data["link_above"]
	if(!isnull(data["link_below"]))
		link_below = data["link_below"]
	if(!isnull(data["link_west"]))
		link_west = data["link_west"]
	if(!isnull(data["link_east"]))
		link_east = data["link_east"]
	if(!isnull(data["air_indoors"]))
		air_indoors = data["air_indoors"]
	if(!isnull(data["air_outdoors"]))
		air_outdoors = data["air_outdoors"]
	if(!isnull(data["orientation"]))
		orientation = data["orientation"]

/**
 * get .dmm path or file
 */
/datum/map_level/proc/resolve_map_path()
	return absolute_path // no relative path support yet

/**
 * get level index in dir
 */
/datum/map_level/proc/z_in_dir(dir)
	return level_in_dir(dir)?.z_index

/**
 * get level datum in dir
 */
/datum/map_level/proc/level_in_dir(dir)
	RETURN_TYPE(/datum/map_level)
	switch(dir)
		if(NORTH)
			return SSmapping.keyed_levels[link_north]
		if(SOUTH)
			return SSmapping.keyed_levels[link_south]
		if(EAST)
			return SSmapping.keyed_levels[link_east]
		if(WEST)
			return SSmapping.keyed_levels[link_west]
		if(UP)
			return SSmapping.keyed_levels[link_above]
		if(DOWN)
			return SSmapping.keyed_levels[link_below]

/**
 * called right after we physically load in, before init
 * called before atom init
 *
 * this is *not* called if we are created from a zlevel, say, when dynamically generating a planet.
 * this is solely for hardcoded map levels to have load behaviors.
 * undefined behavior will result if this is overridden on a level used for dynamic generation.
 *
 * @params
 * * z_index - zlevel we loaded on
 * * generation_callbacks - callbacks to add to perform post_loaded generation. this will be done in a batch before on_loaded_finalize and before atom init.
 */
/datum/map_level/proc/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	return

/**
 * called in a group after all maps and dependencies load **and** generation callbacks fire.
 * called after atom init
 *
 * this is *not* called if we are created from a zlevel, say, when dynamically generating a planet.
 * this is solely for hardcoded map levels to have load behaviors.
 * undefined behavior will result if this is overridden on a level used for dynamic generation.
 *
 * @params
 * * z_index - zlevel we loaded on
 */
/datum/map_level/proc/on_loaded_finalize(z_index)
	return

/**
 * allow deallocation/unload
 */
/datum/map_level/proc/allow_deallocate()
	return TRUE

/datum/map_level/proc/has_trait(trait)
	return trait in traits

/datum/map_level/proc/add_trait(trait)
	if(has_trait(trait))
		return
	LAZYDISTINCTADD(traits, trait)
	if(loaded)
		SSmapping.on_trait_add(src, trait)

/datum/map_level/proc/remove_trait(trait)
	if(!has_trait(trait))
		return
	LAZYREMOVE(traits, trait)
	if(loaded)
		SSmapping.on_trait_del(src, trait)

/datum/map_level/proc/get_attribute(attribute)
	return attributes?[attribute]

/datum/map_level/proc/set_attribute(attribute, value)
	var/old = get_attribute(attribute)
	LAZYSET(attributes, attribute, value)
	if(loaded)
		SSmapping.on_attribute_set(src, attribute, old, value)

/datum/map_level/proc/unset_attribute(attribute)
	var/old = get_attribute(attribute)
	LAZYREMOVE(attributes, attribute)
	if(loaded)
		SSmapping.on_attribute_set(src, attribute, old, null)

/**
 * dynamically generated levels should use this
 */
/datum/map_level/dynamic
	modified = TRUE

/**
 * "free" / unallocated zlevels use this
 */
/datum/map_level/unallocated
	transition = Z_TRANSITION_DISABLED

/**
 * reserved levels for turf reservations use this
 */
/datum/map_level/reserved
	transition = Z_TRANSITION_DISABLED

/datum/map_level/reserved/allow_deallocate()
	return FALSE

/**
 * transit levels for shuttles
 */
/datum/map_level/transit
	transition = Z_TRANSITION_DISABLED
