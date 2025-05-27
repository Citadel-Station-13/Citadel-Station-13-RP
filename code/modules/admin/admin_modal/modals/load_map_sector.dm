//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: sensical admin rights
// todo: better verb category
ADMIN_VERB_DEF(load_map_sector, R_ADMIN, "Load Map Sector", "Load a custom map sector.", VERB_CATEGORY_ADMIN)
	caller.holder.open_admin_modal(/datum/admin_modal/load_map_sector)

/**
 * Modal supporting arbitrary map loads.
 *
 * * Does not support shuttles yet. You must load shuttles separately!
 * * This will always create full /datum/map's. Uploading singular levels
 *   is no longer natively supported for admin tooling,
 *   as the game's backend orchestration
 *   expects to work with abstracted sectors, instead of singular z-level's.
 *
 * todo: ability to load compiled in map defs
 * todo: ability to use a generator for a level
 */
/datum/admin_modal/load_map_sector
	name = "Load Map Sector"
	tgui_interface = "LoadMapSector"
	tgui_update = FALSE

	//* buffer *//

	/// map buffer
	var/datum/map/buffer

	//* load *//

	/// primed for load?
	var/tmp/load_primed = FALSE
	/// all checks pass?
	var/tmp/load_ready = FALSE
	/// loaded?
	var/tmp/load_finished = FALSE
	/// verification errors, if any
	var/tmp/list/load_verification_errors

/datum/admin_modal/load_map_sector/Initialize()
	// no uploading new map sectors while MC is initializing.
	if(!MC_INITIALIZED())
		loud_rejection("Cannot load new map sectors while the server is initializing.")
		return FALSE
	. = ..()
	buffer = new /datum/map/custom
	buffer.name = "Custom Map"

/datum/admin_modal/load_map_sector/Destroy()
	if(buffer)
		// if the buffer is already loaded in, just drop reference
		if(buffer.loaded)
			buffer = null
		else
			QDEL_NULL(buffer)
	return ..()

/datum/admin_modal/load_map_sector/ui_nested_data(mob/user, datum/tgui/ui)
	. = ..()
	.["map"] = ui_map_data()
	for(var/index in 1 to length(buffer.levels))
		.["level-[index]"] = ui_level_index_data(index)

/datum/admin_modal/load_map_sector/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["primed"] = primed
	.["ready"] = ready
	.["levels"] = length(buffer.levels)

/datum/admin_modal/load_map_sector/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["const_airVacuum"] = GAS_STRING_VACUUM
	.["const_airHabitable"] = GAS_STRING_STP
	.["staged"] = ui_staging_data()

/datum/admin_modal/load_map_sector/ui_asset_injection(datum/tgui/ui, list/immediate, list/deferred)
	. = ..()
	deferred += /datum/asset_pack/json/map_system
	deferred += /datum/asset_pack/json/world_typepaths
	deferred += /datum/asset_pack/spritesheet/world_typepaths

/datum/admin_modal/load_map_sector/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("load")
			if(!primed || !ready)
				return TRUE
			load()
			return TRUE
	unprime()

	// this may or may not be set but we're doing it here to avoid too many definitions
	var/target_level_index
	var/datum/map_level/target_level
	if(!isnull(params["levelIndex"]))
		target_level_index = text2num(params["levelIndex"])
		if(target_level_index < 1 || target_level_index > length(buffer.levels))
			return TRUE
		target_level = buffer.levels[target_level_index]

	switch(action)
		if("prime")
			prime()
			. = TRUE
		// map //
		if("mapName")
			update_ui_map_data()
			. = TRUE
		if("mapOrientation")
			if(!(params["setTo"] in GLOB.cardinal))
				return
			buffer.load_orientation = params["setTo"]
			update_ui_map_data()
			. = TRUE
		if("mapCenter")
			buffer.load_auto_center = !buffer.load_auto_center
			update_ui_map_data()
			. = TRUE
		// overmap //
		if("overmapActive")
			overmap_active = !overmap_active
			if(!istype(buffer.overmap_initializer, /datum/overmap_initializer/struct))
				buffer.overmap_initializer = new /datum/overmap_initializer/struct
			update_ui_map_data()
			. = TRUE
		if("overmapX")
			if(!is_safe_number(params["setTo"]))
				return
			buffer.overmap_initializer.manual_position_x = params["setTo"]
			update_ui_map_data()
			. = TRUE
		if("overmapY")
			if(!is_safe_number(params["setTo"]))
				return
			buffer.overmap_initializer.manual_position_y = params["setTo"]
			update_ui_map_data()
			. = TRUE
		if("overmapForcePosition")
			buffer.overmap_initializer.manual_position_is_strong_suggestion = !buffer.overmap_initializer.manual_position_is_strong_suggestion
			update_ui_map_data()
			. = TRUE
		// levels //
		if("newLevel")
			if(length(buffer.levels) > max_upload_levels)
				return TRUE
			create_level()
			. = TRUE
		if("delLevel")
			delete_level_index(target_level_index)
			. = TRUE
		// level //
		if("levelDmm")
			if(owner.owner.is_prompting_for_file())
				return TRUE
			var/loaded_file = owner.owner.prompt_for_file("Upload a .dmm file.", "Upload DMM", 1024 * 1024 * 2)
			var/loaded_file_size = length(loaded_file)
			if(isfile(target_level.path))
				current_upload_size -= length(target_level.path)
			current_upload_size += loaded_file_size
			target_level.path = loaded_file
			update_ui_level_index_data(target_level_index)
			. = TRUE
		if("levelName")
			target_level.name = params["setTo"] || "Custom Level"
			update_ui_level_index_data(target_level_index)
			. = TRUE
		if("levelId")
			target_level.id = params["setTo"] || null
			update_ui_level_index_data(target_level_index)
			. = TRUE
		if("levelDisplayName")
			target_level.display_name = params["setTo"] || "Unknown Sector"
			update_ui_level_index_data(target_level_index)
			. = TRUE
		if("levelDisplayId")
			target_level.display_id = params["setTo"] || null
			update_ui_level_index_data(target_level_index)
			. = TRUE
		if("levelAddTrait")
			target_level.add_trait(params["trait"])
			update_ui_level_index_data(target_level_index)
			. = TRUE
		if("levelDelTrait")
			target_level.remove_trait(params["trait"])
			update_ui_level_index_data(target_level_index)
			. = TRUE
		if("levelSetAttribute")
			target_level.set_attribute(params["attribute"], params["value"])
			update_ui_level_index_data(target_level_index)
			. = TRUE
		if("levelBaseTurf")
			target_level.base_turf = text2path(params["type"]) || world.turf
			update_ui_level_index_data(target_level_index)
			. = TRUE
		if("levelBaseArea")
			target_level.base_area = text2path(params["type"]) || world.turf
			. = TRUE
		if("levelStructXYZ")
			target_level.struct_x = params["x"]
			target_level.struct_y = params["y"]
			target_level.struct_z = params["z"]
			update_ui_level_index_data(target_level_index)
			. = TRUE
		if("levelAirIndoors")
			. = TRUE
			if(!SSair.validate_gas_string(params["air"]))
				loud_rejection("Gas string [params["air"]] failed validation.")
				return
			target_level.air_indoors = params["air"]
			update_ui_level_index_data(target_level_index)
		if("levelAirOutdoors")
			. = TRUE
			if(!SSair.validate_gas_string(params["air"]))
				loud_rejection("Gas string [params["air"]] failed validation.")
				return
			target_level.air_outdoors = params["air"]
			update_ui_level_index_data(target_level_index)
			. = TRUE
		if("levelCeilingHeight")
			target_level.ceiling_height = params["height"]
			update_ui_level_index_data(target_level_index)
			. = TRUE

/datum/admin_modal/load_map_sector/proc/ui_map_data()
	var/list/serialized_overmap_initializer = null
	if(buffer.overmap_initializer)
		serialized_overmap_initializer = list(
			"x" = buffer.overmap_initializer.manual_position_x,
			"y" = buffer.overmap_initializer.manual_position_y,
			"forcePos" = buffer.overmap_initializer.manual_position_is_strong_suggestion,
		)
	return list(
		"name" = buffer.name,
		"orientation" = buffer.load_orientation,
		"center" = buffer.load_auto_center,
		"overmap" = serialized_overmap_initializer,
	)

/datum/admin_modal/load_map_sector/proc/update_ui_map_data()
	push_ui_data(
		nested_data = list(
			"map" = ui_map_data(),
		),
	)

/datum/admin_modal/load_map_sector/proc/ui_level_index_data(index)
	var/datum/map_level/level = buffer.levels[index]
	return list(
		"id" = level.id,
		"displayId" = level.display_id,
		"name" = level.name,
		"displayName" = level.display_name,
		"traits" = level.traits,
		"attributes" = level.attributes,
		"baseTurf" = level.base_turf,
		"baseArea" = level.base_area,
		"structPos" = level.struct_create_pos,
		"airIndoors" = level.air_indoors,
		"airOutdoors" = level.air_outdoors,
		"ceilingHeight" = level.ceiling_height,
		"fileName" = "[level.path]",
	)

/datum/admin_modal/load_map_sector/proc/update_ui_level_index_data(index)
	push_ui_data(
		nested_data = list(
			"level-[index]" = ui_level_index_data(index),
		),
	)

/datum/admin_modal/load_map_sector/proc/update_all_ui_level_datas()
	for(var/i in 1 to length(buffer.levels))
		update_ui_level_index_data(i)

#warn below

/datum/admin_modal/load_map_sector/proc/prime()
	computed_errors = list()
	world_maxz_at_prime = world.maxz

	var/passed = TRUE

	for(var/i in 1 to length(buffer.levels))
		var/datum/map_level/checking_level = buffer.levels
		if(!istype(checking_level))
			passed = FALSE
			computed_errors += "Index [i] is not a map level. What happened? Yell at coders."
			continue
	if(!buffer.validate(TRUE, computed_errors))
		passed = FALSE

	primed = passed
	ready = passed

	update_static_data()

/datum/admin_modal/load_map_sector/proc/unprime()
	primed = FALSE
	ready = FALSE

	world_maxz_at_prime = null

	computed_errors = null

	update_static_data()

/datum/admin_modal/load_map_sector/proc/load()
	if(world.maxz != world_maxz_at_prime)
		unprime()
		return FALSE
	if(loaded)
		return TRUE
	. = do_load()
	if(!.)
		return
	loaded = TRUE

/datum/admin_modal/load_map_sector/proc/do_load()
	set waitfor = FALSE

	. = TRUE
	SSmapping.load_map(buffer)

/datum/admin_modal/load_map_sector/proc/create_level()
	var/datum/map_level/appending = new(buffer)
	appending.name = "Custom Level"
	appending.display_name = "Unknown Sector"
	LAZYADD(buffer.levels, appending)
	update_ui_level_index_data(length(buffer.levels))
	update_ui_data()

/datum/admin_modal/load_map_sector/proc/delete_level_index(target_level_index)
	var/datum/map_level/obliterating = buffer.levels[target_level_index]
	buffer.levels.Cut(target_level_index, target_level_index + 1)
	QDEL_NULL(obliterating)
	for(var/updating in target_level_index to length(buffer.levels))
		update_ui_level_index_data(updating)
	update_ui_data()
