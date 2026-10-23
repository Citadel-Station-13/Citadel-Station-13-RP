//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Modal to upload a new shuttle template
 */
/datum/admin_modal/upload_shuttle_template
	name = "Upload Shuttle Template"
	tgui_interface = "UploadShuttleTemplate"
	tgui_autoupdate = FALSE

	/// file buffer
	var/file_buffer
	/// direction the shuttle is facing in the file
	var/facing_dir = SOUTH
	/// parse buffer
	/// * never carried over by ref to anything else; this ref will always be owned
	var/datum/dmm_parsed/parse_buffer
	/// checks passed?
	var/checks_passed = FALSE
	/// already loaded?
	var/finalized = FALSE

	/**
	 * ID to use.
	 * * This is optional; if left null, an ID will be auto-generated.
	 */
	var/chosen_id
	var/chosen_name
	var/chosen_desc
	var/chosen_fluff
	/// * never carried over by ref to anything else; this ref will always be owned
	var/datum/shuttle_descriptor/chosen_descriptor

#warn ui

/datum/admin_modal/upload_shuttle_template/Initialize()
	// no uploading new shuttle templates while MC is initializing.
	if(!MC_INITIALIZED())
		loud_rejection("Cannot upload new shuttle templates while the server is initializing.")
		return FALSE
	chosen_descriptor = new
	return ..()

/datum/admin_modal/upload_shuttle_template/Destroy()
	QDEL_NULL(chosen_descriptor)
	QDEL_NULL(parse_buffer)
	return ..()

#warn impl

/datum/admin_modal/upload_shuttle_template/ui_data(mob/user, datum/tgui/ui)
	. = ..()

	.["dmm"] = file_buffer ? "[file_buffer]" : null
	.["facingDir"] = facing_dir

	.["id"] = chosen_id
	.["name"] = chosen_name
	.["desc"] = chosen_desc
	.["fluff"] = chosen_fluff

	.["descriptor"] = list(
		"displayName" = chosen_descriptor.display_name,
		"mass" = chosen_descriptor.mass,
		"atmosLanding" = chosen_descriptor.allow_atmospheric_landing,
		"preferredOrientation" = chosen_descriptor.preferred_orientation,
		"jumpChargeTime" = chosen_descriptor.jump_charging_time,
		"jumpMoveTime" = chosen_descriptor.jump_move_time,
		"overmapBounds" = list(
			chosen_descriptor.overmap_bound_width,
			chosen_descriptor.overmap_bound_height,
		),
		"overmapName" = chosen_descriptor.overmap_legacy_name,
		"overmapDesc" = chosen_descriptor.overmap_legacy_desc,
		"overmapColor" = isttext(chosen_descriptor.overmap_icon_color) ? chosen_descriptor.overmap_icon_color : "#ffffff",
	)

	.["checksPassed"] = checks_passed
	.["finalized"] = finalized

/datum/admin_modal/upload_shuttle_template/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	switch(action)
		if("dmm")
			if(owner.owner.is_prompting_for_file())
				return TRUE
			var/loaded_file = owner.owner.prompt_for_file_or_null("Upload a .dmm file.", "Upload DMM", 1024 * 1024 * 2)
			file_buffer = loaded_file
			. = TRUE
		if("setFacingDir")
			var/dir = params["dir"]
			if(!(dir in global.cardinals))
				return TRUE
			facing_dir = dir
			. = TRUE
		if("setId")
			if(!istext(params["id"]) && params["id"])
				return TRUE
			// null is valid, defaults to auto-generated
			chosen_id = params["id"] || null
			. = TRUE
		if("setName")
			if(!istext(params["name"]))
				return TRUE
			chosen_name = params["name"]
			. = TRUE
		if("setDesc")
			if(!istext(params["desc"]))
				return TRUE
			chosen_desc = params["desc"]
			. = TRUE
		if("setFluff")
			if(!istext(params["fluff"]))
				return TRUE
			chosen_fluff = params["fluff"]
			. = TRUE
		if("setDescriptorDisplayName")
		if("setDescriptorMass")
		if("setDescriptorAtmosLanding")
		if("setDescriptorPreferredOrientation")
		if("setDescriptorJumpChargeTime")
		if("setDescriptorJumpMoveTime")
		if("setDescriptorOvermapName")
		if("setDescriptorOvermapDesc")
		if("setDescriptorOvermapSprite")
		if("setDescriptorOvermapColor")
		if("setDescriptorOvermapSize")


		if("check")
		if("upload")

	if(.)
		mark_dirty()

/datum/admin_modal/upload_shuttle_template/proc/attempt_finalize()
	if(!checks_passed)
		return
	if(finalized)
		return
	finalized = TRUE
	finalize()
	update_ui_data()

/datum/admin_modal/upload_shuttle_template/proc/validate()
	var/list/errors = list()
	if(!file_buffer)
		errors += "A .dmm file is required."
	if(!chosen_name)
		errors += "A name is required."
	if(!chosen_desc)
		errors += "A description is required."
	#warn impl

	if(length(errors))
		#warn early return
	update_ui_data()

/datum/admin_modal/upload_shuttle_template/proc/attempt_parse_and_check_buffer()
	#warn impl

/datum/admin_modal/upload_shuttle_template/proc/mark_dirty()
	if(!checks_passed)
		return
	checks_passed = FALSE
	update_ui_data()

/datum/admin_modal/upload_shuttle_template/proc/finalize()
	var/datum/shuttle_template/created_template = new(file_buffer)
	created_template.facing_dir = facing_dir
	created_template.name = chosen_name
	created_template.desc = chosen_desc
	created_template.fluff = chosen_fluff
	created_template.display_name = chosen_descriptor.display_name
	created_template.category = "Uploaded"
	created_template.descriptor = chosen_descriptor.clone()

	SSshuttle.register_shuttle_template(created_template)
	spawn(0)
		qdel(src)
	return TRUE
