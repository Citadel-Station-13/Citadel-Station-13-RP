//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Modal supporting arbitrary map uploads.
 *
 * * Does not support shuttles yet. You must upload shuttles separately!
 * * This will always create sectors with structs. Uploading singular levels
 *   is no longer natively supported, as the game's backend orchestration
 *   expects to work with abstracted sectors, instead of singular z-level's.
 *
 * todo: traits / attributes support
 */
/datum/admin_modal/upload_map_sector
	#warn write modal
	tgui_interface = "AdminModalUploadMapSector"
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

	/// current max size
	var/current_max_x = 0
	/// current max size
	var/current_max_y = 0

	/// map level's
	var/list/datum/map_level/level_buffers

#warn impl


/datum/admin_modal/upload_map_sector/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/admin_modal/upload_map_sector/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/admin_modal/upload_map_sector/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("upload")
		if("structXYZ")
