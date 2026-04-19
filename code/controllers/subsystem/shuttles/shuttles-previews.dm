//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

//* Previews *//

/datum/controller/subsystem/shuttle/proc/generate_preview(datum/shuttle/instance, for_path_md5)
	var/preview_path = get_preview_path(for_path_md5)
	if(fexists(preview_path))
		return
	// oh boy
	var/list/axis_aligned_bounding_box = instance.anchor.absolute_llx_lly_urx_ury_coords_at()
	if(!instance.anchor.z)
		return FALSE

	var/icon/returns = _get_flat_icon_of_map_bounds(
		axis_aligned_bounding_box[1],
		axis_aligned_bounding_box[2],
		axis_aligned_bounding_box[3],
		axis_aligned_bounding_box[4],
		instance.anchor.z,
	)
	var/icon/generated_icon = returns[1]
	var/took_ms = returns[2]

	fcopy(icon_in_question, preview_path)
	subsystem_log("Generated shuttle preview for [instance.id] ([for_path_md5]) in [took_ms]ms")

	return TRUE

/datum/controller/subsystem/shuttle/proc/get_preview_path(for_path_md5)
	return SSwebroot.get_webroot_path("shuttle_previews/[for_path_md5].png")

/datum/controller/subsystem/shuttle/proc/get_url_for_preview(for_path_md5)
	return SSwebroot.get_webroot_url("shuttle_previews/[for_path_md5].png")
