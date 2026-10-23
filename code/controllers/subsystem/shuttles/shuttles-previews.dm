//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

//* Previews *//

/datum/controller/subsystem/shuttle/proc/generate_all_previews_for_loaded_templates(hardcoded_only = TRUE, force_regenerate = FALSE)
	UNTIL(!preview_generation_mutex)
	preview_generation_mutex = TRUE

	to_chat(world, SPAN_BOLDANNOUNCE("Generating shuttle previews for all loaded shuttles. This will lag badly."))

	var/took_s_with_tick_check = REALTIMEOFDAY
	var/generated = 0

	for(var/id in templates_by_id)
		var/datum/shuttle_template/template = templates_by_id[id]
		if(template.preview_generated && !force_regenerate)
			continue
		if(hardcoded_only && !template.hardcoded)
			continue
		generated += 1

		generate_preview_for_template(template)

	took_s_with_tick_check = REALTIMEOFDAY - took_s_with_tick_check

	to_chat(world, SPAN_BOLDANNOUNCE("Generated shuttle previews for [generated] non-generated templates in [round(took_s_with_tick_check, 0.1)]s"))

	preview_generation_mutex = FALSE

/**
 * This doesn't check if a preview exists, and will forcefully generate one anyways.
 *
 * @return TRUE / FALSE whether the preview was successfully generated
 */
/datum/controller/subsystem/shuttle/proc/generate_preview_for_template(datum/shuttle_template/template)
	var/datum/shuttle/loaded = create_shuttle(template)
	if(!loaded)
		. = FALSE
		CRASH("failed to generate - could not load shuttle for template [template.id].")
	. = generate_preview(loaded, template.get_path_md5())
	qdel(loaded, force = TRUE)

/**
 * Checks filesystem to see if a preview is generated.
 */
/datum/controller/subsystem/shuttle/proc/has_generated_preview_for_template(datum/shuttle_template/template)
	var/md5 = template.get_path_md5()
	if(!md5)
		return FALSE
	return fexists(get_preview_path(md5))

/datum/controller/subsystem/shuttle/proc/generate_preview(datum/shuttle/instance, for_path_md5)
	UNTIL(!preview_generation_mutex)

	preview_generation_mutex = TRUE
	generate_preview_impl(instance, for_path_md5)
	preview_generation_mutex = FALSE

/datum/controller/subsystem/shuttle/proc/generate_preview_impl(datum/shuttle/instance, for_path_md5)
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

	fcopy(generated_icon, preview_path)
	subsystem_log("Generated shuttle preview for [instance.id] ([for_path_md5]) in [took_ms]ms")

	return TRUE

/datum/controller/subsystem/shuttle/proc/get_preview_path(for_path_md5)
	return SSwebroot.get_webroot_path("shuttle_previews/[for_path_md5].png")

/datum/controller/subsystem/shuttle/proc/get_url_for_preview(for_path_md5)
	return SSwebroot.get_webroot_url("shuttle_previews/[for_path_md5].png")
