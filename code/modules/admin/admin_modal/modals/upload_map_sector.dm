//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: sensical admin rights
// todo: better verb category
ADMIN_VERB_DEF(upload_map_sector, R_ADMIN, "Create Map Sector", "Create or upload a custom map.", VERB_CATEGORY_ADMIN)
	caller.holder.open_admin_modal(/datum/admin_modal/upload_map_sector)

/**
 * Modal supporting arbitrary map uploads.
 *
 * * Does not support shuttles yet. You must upload shuttles separately!
 * * This will always create sectors with structs. Uploading singular levels
 *   is no longer natively supported, as the game's backend orchestration
 *   expects to work with abstracted sectors, instead of singular z-level's.
 * * This does not currently support invoking map generation during an upload.
 */
/datum/admin_modal/upload_map_sector
	name = "Upload Map Sector"
	tgui_interface = "UploadMapSector"
	tgui_update = FALSE

	//* constraints *//

	/// in bytes
	var/max_upload_size = 1024 * 1024 * 10
	/// in levels
	var/max_upload_levels = 9

	//* buffer *//

	/// in bytes
	var/current_upload_size = 0
	/// in levels
	var/current_upload_levels = 0

	/// map buffer
	var/datum/map/buffer
	/// is overmap active?
	var/overmap_active = TRUE

	//* load *//

	/// primed for load?
	var/primed = FALSE
	/// all checks pass?
	var/ready = FALSE

	var/tmp/world_maxz_at_prime

	var/tmp/computed_width
	var/tmp/computed_height
	var/tmp/computed_turf_count
	var/tmp/computed_utilization
	var/tmp/computed_start_z
	var/tmp/computed_end_z
	var/tmp/list/computed_errors

/datum/admin_modal/upload_map_sector/Initialize()
	// no uploading new map sectors while MC is initializing.
	if(!MC_INITIALIZED())
		loud_rejection("Cannot upload map sectors while the server is initializing.")
		return FALSE
	..()
	buffer = new
	buffer.name = "Custom Map"

/datum/admin_modal/upload_map_sector/Destroy()
	if(buffer)
		// unreference only if the buffer is already loaded in
		if(buffer.loaded)
			buffer = null
		else
			QDEL_NULL(buffer)
	return ..()

#warn impl

/datum/admin_modal/upload_map_sector/ui_module_data(mob/user, datum/tgui/ui)
	. = ..()
	.["map"] = map_data()
	.["overmap"] = overmap_data()
	for(var/index in 1 to length(buffer.levels))
		.["level-[index]"] = level_index_data(index)

/datum/admin_modal/upload_map_sector/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["primed"] = primed
	.["ready"] = ready
	.["levels"] = length(buffer.levels)
	.["staged"] = primed ? list(

	) : null

/datum/admin_modal/upload_map_sector/ui_asset_injection(datum/tgui/ui, list/immediate, list/deferred)
	. = ..()
	deferred += /datum/asset_pack/json/map_system
	deferred += /datum/asset_pack/json/world_typepaths
	deferred += /datum/asset_pack/spritesheet/world_typepaths

/datum/admin_modal/upload_map_sector/ui_act(action, list/params, datum/tgui/ui)
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
	var/target_level_index = text2num(params["levelIndex"])
	switch(action)
		if("prime")
			prime()
			. = TRUE
		// map //
		if("mapName")
			update_map_data()
			. = TRUE
		if("mapOrientation")
			update_map_data()
			. = TRUE
		if("mapCenter")
			update_map_data()
			. = TRUE
		// overmap //
		if("overmapActive")
			update_overmap_data()
			. = TRUE
		if("overmapX")
			update_overmap_data()
			. = TRUE
		if("overmapY")
			update_overmap_data()
			. = TRUE
		if("overmapForcePosition")
			update_overmap_data()
			. = TRUE
		// levels //
		if("newLevel")
			create_level()
			. = TRUE
		if("delLevel")
			delete_level_index(target_level_index)
			. = TRUE
		// level //
		if("levelDmm")
			update_level_index_data(target_level_index)
			. = TRUE
		if("levelName")
			update_level_index_data(target_level_index)
			. = TRUE
		if("levelId")
			update_level_index_data(target_level_index)
			. = TRUE
		if("levelDisplayName")
			update_level_index_data(target_level_index)
			. = TRUE
		if("levelDisplayId")
			update_level_index_data(target_level_index)
			. = TRUE
		if("levelAddTrait")
			update_level_index_data(target_level_index)
			. = TRUE
		if("levelDelTrait")
			update_level_index_data(target_level_index)
			. = TRUE
		if("levelSetAttribute")
			update_level_index_data(target_level_index)
			. = TRUE
		if("levelBaseTurf")
			update_level_index_data(target_level_index)
			. = TRUE
		if("levelBaseArea")
			. = TRUE
		if("levelStructXYZ")
			update_level_index_data(target_level_index)
			. = TRUE
		if("levelAirIndoors")
			update_level_index_data(target_level_index)
			. = TRUE
		if("levelAirOutdoors")
			update_level_index_data(target_level_index)
			. = TRUE
		if("levelCeilingHeight")
			update_level_index_data(target_level_index)
			. = TRUE


#warn impl all

/datum/admin_modal/upload_map_sector/proc/map_data()
	return list(
		"name" = buffer.name,
		"orientation" = buffer.orientation,
		"center" = buffer.center,
	)

/datum/admin_modal/upload_map_sector/proc/update_map_data()
	push_ui_modules(
		updates = list(
			"map" = map_data(),
		),
	)

/datum/admin_modal/upload_map_sector/proc/overmap_data()
	return list(
	)

/datum/admin_modal/upload_map_sector/proc/update_overmap_data()
	push_ui_modules(
		updates = list(
			"overmap" = overmap_data(),
		),
	)

/datum/admin_modal/upload_map_sector/proc/level_index_data(index)

/datum/admin_modal/upload_map_sector/proc/update_level_index_data(index)
	push_ui_modules(
		updates = list(
			"level-[index]" = level_index_data(index),
		),
	)

/datum/admin_modal/upload_map_sector/proc/prime()
	#warn check bounds
	#warn sort up/down levels as needed

/datum/admin_modal/upload_map_sector/proc/unprime()
	primed = FALSE
	ready = FALSE

	world_maxz_at_prime = null

	computed_width = \
	computed_height = \
	computed_start_z = \
	computed_end_z = \
	computed_turf_count = \
	computed_errors = \
	computed_utilization = null

/datum/admin_modal/upload_map_sector/proc/load()
	if(world.maxz != world_maxz_at_prime)
		unprime()
		return FALSE


/datum/admin_modal/upload_map_sector/proc/create_level()
	var/datum/map_level/appending
	#warn check & track turf utilization

/datum/admin_modal/upload_map_sector/proc/delete_level_index(target_level_index)
	var/datum/map_level/obliterating = buffer.levels[target_level_index]
	buffer.levels.Cut(target_level_index, target_level_index + 1)
	QDEL_NULL(obliterating)
	for(var/updating in target_level_index to length(buffer.levels))
		update_level_index_data(updating)
	#warn check & track turf utilization

