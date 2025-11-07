//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

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
	/// enable overmaps?
	var/buffer_overmap_active = FALSE
	/// overmap initializer to use with buffer
	/// * stored separately for injection as we can toggle whether or not to use it
	var/datum/overmap_initializer/map/buffer_overmap_initializer

	//* load *//

	/// all checks pass?
	var/tmp/load_ready = FALSE
	/// started load?
	var/tmp/load_started = FALSE
	/// loaded?
	var/tmp/load_finished = FALSE

/datum/admin_modal/load_map_sector/Initialize()
	// no uploading new map sectors while MC is initializing.
	if(!MC_INITIALIZED())
		loud_rejection("Cannot load new map sectors while the server is initializing.")
		return FALSE
	. = ..()
	buffer = new /datum/map/custom
	buffer.name = "Custom Map"
	buffer_overmap_initializer = new

/datum/admin_modal/load_map_sector/Destroy()
	if(buffer)
		// if the buffer is already loaded in, just drop reference
		if(buffer.loaded)
			buffer = null
		else
			QDEL_NULL(buffer)
	return ..()

/datum/admin_modal/load_map_sector/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	var/load_status = "waiting"
	if(load_ready)
		load_status = "ready"
	if(load_started)
		load_status = "loading"
	if(load_finished)
		load_status = "finished"
	.["status"] = load_status
	.["levels"] = length(buffer.levels)

/datum/admin_modal/load_map_sector/ui_nested_data(mob/user, datum/tgui/ui)
	. = ..()
	.["map"] = ui_map_data()
	for(var/index in 1 to length(buffer.levels))
		.["level-[index]"] = ui_level_index_data(index)

/datum/admin_modal/load_map_sector/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["const_airVacuum"] = GAS_STRING_VACUUM
	.["const_airHabitable"] = GAS_STRING_STP

/datum/admin_modal/load_map_sector/ui_asset_injection(datum/tgui/ui, list/immediate, list/deferred)
	. = ..()
	deferred += /datum/asset_pack/json/MapSystem
	deferred += /datum/asset_pack/json/WorldTypepaths

/datum/admin_modal/load_map_sector/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("load")
			if(!load_ready || load_finished)
				return TRUE
			load()
			return TRUE

	if(load_started || load_finished)
		// DO NOT FOR THE LOVE OF GOD PROCEED THEY WILL BE DIRECTLY MODIFYING
		// A LOADED MAP THAT WOULD BE REALLY FUCKING BAD
		return TRUE

	// this may or may not be set but we're doing it here to avoid too many definitions
	var/target_level_index
	var/datum/map_level/target_level
	if(!isnull(params["levelIndex"]))
		target_level_index = text2num(params["levelIndex"])
		if(target_level_index < 1 || target_level_index > length(buffer.levels))
			return TRUE
		target_level = buffer.levels[target_level_index]

	switch(action)
		if("ready")
			validate_and_ready()
			return TRUE
		// map //
		if("mapName")
			buffer.name = params["setTo"] || "Custom Map"
			update_ui_map_data()
			. = TRUE
		if("mapOrientation")
			if(!(params["setTo"] in GLOB.cardinal))
				return
			buffer.load_orientation = params["setTo"]
			update_ui_map_data()
			. = TRUE
		if("mapCenter")
			buffer.load_auto_center = !!params["setTo"]
			update_ui_map_data()
			. = TRUE
		// overmap //
		if("overmapActive")
			buffer_overmap_active = !!params["setTo"]
			update_ui_map_data()
			. = TRUE
		if("overmapPosToggle")
			if(params["setTo"])
				buffer_overmap_initializer.manual_position_x = buffer_overmap_initializer.manual_position_y = 1
			else
				buffer_overmap_initializer.manual_position_x = buffer_overmap_initializer.manual_position_y = null
			update_ui_map_data()
			. = TRUE
		if("overmapX")
			if(!is_safe_number(params["setTo"]))
				return
			buffer_overmap_initializer.manual_position_x = round(params["setTo"], 1)
			update_ui_map_data()
			. = TRUE
		if("overmapY")
			if(!is_safe_number(params["setTo"]))
				return
			buffer_overmap_initializer.manual_position_y = round(params["setTo"], 1)
			update_ui_map_data()
			. = TRUE
		if("overmapForcePosition")
			buffer_overmap_initializer.manual_position_is_strong_suggestion = !!params["setTo"]
			update_ui_map_data()
			. = TRUE
		// levels //
		if("newLevel")
			create_level()
			. = TRUE
		if("delLevel")
			delete_level_index(target_level_index)
			. = TRUE
		// level //
		if("levelDmmUpload")
			if(owner.owner.is_prompting_for_file())
				return TRUE
			var/loaded_file = owner.owner.prompt_for_file_or_null("Upload a .dmm file.", "Upload DMM", 1024 * 1024 * 2)
			target_level.path = loaded_file
			update_ui_level_index_data(target_level_index)
			. = TRUE
		if("levelDmmClear")
			target_level.path = null
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
		if("levelDelAttribute")
			target_level.unset_attribute(params["attribute"])
			update_ui_level_index_data(target_level_index)
			. = TRUE
		if("levelBaseTurf")
			target_level.base_turf = text2path(params["type"]) || world.turf
			if(!ispath(target_level.base_turf, /turf))
				target_level.base_turf = world.turf
			update_ui_level_index_data(target_level_index)
			. = TRUE
		if("levelBaseArea")
			target_level.base_area = text2path(params["type"]) || world.turf
			if(!ispath(target_level.base_turf, /area))
				target_level.base_area = world.area
			. = TRUE
		if("levelStructX")
			target_level.struct_x = params["val"]
			update_ui_level_index_data(target_level_index)
			. = TRUE
		if("levelStructY")
			target_level.struct_y = params["val"]
			update_ui_level_index_data(target_level_index)
			. = TRUE
		if("levelStructZ")
			target_level.struct_z = params["val"]
			update_ui_level_index_data(target_level_index)
			. = TRUE
		if("levelAirIndoors")
			. = TRUE
			target_level.air_indoors = params["air"]
			update_ui_level_index_data(target_level_index)
		if("levelAirOutdoors")
			. = TRUE
			target_level.air_outdoors = params["air"]
			update_ui_level_index_data(target_level_index)
			. = TRUE
		if("levelCeilingHeight")
			target_level.ceiling_height = params["height"]
			update_ui_level_index_data(target_level_index)
			. = TRUE

	mark_dirty()

/datum/admin_modal/load_map_sector/proc/ui_map_data()
	var/list/serialized_overmap_initializer = null
	serialized_overmap_initializer = list(
		"x" = buffer_overmap_initializer.manual_position_x,
		"y" = buffer_overmap_initializer.manual_position_y,
		"forcePos" = buffer_overmap_initializer.manual_position_is_strong_suggestion,
		"enabled" = buffer_overmap_active,
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
		"structX" = level.struct_x,
		"structY" = level.struct_y,
		"structZ" = level.struct_z,
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

/datum/admin_modal/load_map_sector/proc/validate_and_ready()
	var/list/errors_out = list()

	var/passed = buffer.validate(TRUE, errors_out)

	if(passed)
		load_ready = TRUE
	else
		// TODO: instead of to_chat'ing, just send the data through TGUI dynamic modal / popup system once that's made
		var/rendered = list()
		for(var/error in errors_out)
			rendered += "<li>[error]</li>"
		rendered = jointext(rendered, "")
		to_chat(owner.owner, "<div><center>Map validation errors</center><hr><ul>[rendered]</ul></div>")

	update_ui_data()

/datum/admin_modal/load_map_sector/proc/validate_additional_map(datum/map/map, list/errors_out)
	. = TRUE
	for(var/datum/map_level/level as anything in map.levels)
		. = . && validate_additional_level(level, map, errors_out)

/datum/admin_modal/load_map_sector/proc/validate_additional_level(datum/map_level/level, datum/map/map, list/errors_out)
	. = TRUE
	if(!SSair.validate_gas_string(level.air_indoors))
		errors_out?.Add("Level with ID [level.id] had invalid air_indoors gas string [level.air_indoors]")
		. = FALSE
	if(!SSair.validate_gas_string(level.air_outdoors))
		errors_out?.Add("Level with ID [level.id] had invalid air_outdoors gas string [level.air_outdoors]")
		. = FALSE

/datum/admin_modal/load_map_sector/proc/mark_dirty()
	load_ready = FALSE
	update_ui_data()

/datum/admin_modal/load_map_sector/proc/load()
	if(load_started || load_finished)
		return TRUE
	load_started = TRUE
	log_and_message_admins("is loading map sector '[buffer.name]' with [length(buffer.levels)] levels", owner.owner)
	log_admin("[key_name(owner.owner)] is loading a map sector with parameters [json_encode(buffer.serialize())]")
	update_ui_data()
	var/start_time = REALTIMEOFDAY
	. = do_load()
	var/end_time = REALTIMEOFDAY
	if(!.)
		return
	load_finished = TRUE
	log_and_message_admins("loaded '[buffer.name]' with [length(buffer.levels)] levels in [round((end_time - start_time) * 0.1, 0.1)] seconds", owner.owner)
	update_ui_data()
	// TODO: show feedback in UI before closing?
	qdel(src)

/datum/admin_modal/load_map_sector/proc/do_load()
	if(buffer_overmap_active)
		buffer.overmap_initializer = buffer_overmap_initializer
	return SSmapping.load_map(buffer)

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
