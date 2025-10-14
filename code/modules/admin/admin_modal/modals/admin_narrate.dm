//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/admin_modal/admin_narrate
	name = "Admin Narrate"
	/**
	 * Target. Also determines what modes we can change to.
	 * ### in global, lobby mode
	 * Ignored.
	 * ### in overmap mode
	 * Can be atom, map_level, map, or overmap entity
	 * ### in sector mode
	 * Can be atom, map_level, map
	 * ### in level mode
	 * Can be atom, map_level
	 * ### in range mode
	 * Can be atom
	 * ### in direct mode
	 * Can be movable that is a or can hold mob(s), or client
	 */
	var/atom/target

	//* i'm so sorry lohikar but i don't believe in define spam for this *//
	var/const/M_GLOBAL = "global"
	var/const/M_SECTOR = "sector"
	var/const/M_OVERMAP = "overmap"
	var/const/M_LEVEL = "level"
	var/const/M_RANGE = "range"
	var/const/M_DIRECT = "direct"
	var/const/M_LOBBY = "lobby"

	/// text to send (raw html)
	var/unsafe_raw_html_to_send

	/// narrate mode
	var/mode

	/// use line of sight when doing in range?
	var/use_los = FALSE
	/// use range in tiles; in overmaps, this is multiples of WORLD_ICON_SIZE
	var/use_range = 14

	var/const/MAX_LOS_RANGE = 35
	var/const/MAX_ANY_RANGE = 1024

	/// our identifying color
	var/narrate_visual_color
	/// our target image
	//  TODO: visualize it
	// var/image/narrate_target_image

/datum/admin_modal/admin_narrate/Initialize(atom/target)
	. = ..()
	if(!.)
		return
	set_target(target)
	src.narrate_visual_color = rgb(arglist(hsl2rgb(rand(0, 360), rand(0, 360), rand(125, 360))))

	var/list/possible_modes = resolve_modes()
	if(length(possible_modes))
		src.mode = possible_modes[1]
	else
		return FALSE

/datum/admin_modal/admin_narrate/Destroy()
	set_target(null)
	return ..()

/datum/admin_modal/admin_narrate/proc/set_target(atom/target)
	if(src.target)
		on_unset_target(src.target)
	src.target = target
	if(src.target)
		on_set_target(src.target)

/datum/admin_modal/admin_narrate/proc/on_unset_target(atom/new_target)
	//  TODO: visualize it
	UnregisterSignal(target, COMSIG_PARENT_QDELETING)

/datum/admin_modal/admin_narrate/proc/on_set_target(atom/new_target)
	//  TODO: visualize it
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(on_target_del))

/datum/admin_modal/admin_narrate/proc/on_target_del(datum/source)
	if(source != target)
		CRASH("how was target del signal invoked by something that is not our target?")
	set_target(null)

/**
 * @return list of M_ modes
 */
/datum/admin_modal/admin_narrate/proc/resolve_modes()
	var/datum/resolved = target
	if(!resolved)
		return list(
			/datum/admin_modal/admin_narrate::M_GLOBAL,
			/datum/admin_modal/admin_narrate::M_LOBBY,
		)
	. = list()

	if(istype(resolved, /obj/overmap/entity))
		. += /datum/admin_modal/admin_narrate::M_DIRECT
		. += /datum/admin_modal/admin_narrate::M_OVERMAP
	else if(isatom(resolved))
		if(ismovable(resolved))
			var/atom/movable/casted = resolved
			if(casted.admin_resolve_narrate())
				// compatible with direct-narrate
				. += /datum/admin_modal/admin_narrate::M_DIRECT
		. += /datum/admin_modal/admin_narrate::M_RANGE
		. += /datum/admin_modal/admin_narrate::M_LEVEL
		. += /datum/admin_modal/admin_narrate::M_SECTOR
		. += /datum/admin_modal/admin_narrate::M_OVERMAP
	else if(istype(resolved, /datum/map_level))
		var/datum/map_level/casted = resolved
		. += /datum/admin_modal/admin_narrate::M_LEVEL
		. += /datum/admin_modal/admin_narrate::M_SECTOR
		if(get_overmap_sector(locate(1, 1, casted.z_index)))
			. += /datum/admin_modal/admin_narrate::M_OVERMAP
	else if(istype(resolved, /datum/map))
		. += /datum/admin_modal/admin_narrate::M_SECTOR
		// TODO: check for overmap binding & add overmap if it's there

/**
 * @return list of mobs, or null if invalid
 */
/datum/admin_modal/admin_narrate/proc/resolve_hearers()
	// Clients are not allowed in output list; we want mobs, not clients.
	. = list()
	switch(mode)
		if(M_GLOBAL)
			// do not use client refs directly to prevent gc issues if delayed
			for(var/client/C as anything in GLOB.clients)
				. += C.mob
		if(M_SECTOR)
			var/atom/resolved = target
			var/turf/maybe_target_turf = get_turf(resolved)
			var/datum/map_level/maybe_target_map_level
			if(maybe_target_turf)
				maybe_target_map_level = SSmapping.ordered_levels[maybe_target_turf.z]
			if(!maybe_target_map_level)
				return null
			for(var/client/C as anything in GLOB.clients)
				var/turf/maybe_turf = get_turf(C.mob)
				if(maybe_turf)
					var/datum/map_level/maybe_map_level = SSmapping.ordered_levels[maybe_turf.z]
					if(maybe_map_level?.parent_map == maybe_target_map_level.parent_map)
						. += C.mob
		if(M_OVERMAP)
			var/datum/resolved = target
			var/obj/overmap/entity/resolved_entity
			if(istype(resolved, /obj/overmap/entity))
				resolved_entity = resolved
			else if(istype(resolved, /atom))
				resolved_entity = get_overmap_sector(get_turf(resolved))
			else if(istype(resolved, /datum/map_level))
				var/datum/map_level/casted = resolved
				resolved_entity = get_overmap_sector(locate(1, 1, casted.z_index))
				// TODO: do something
			else if(istype(resolved, /datum/map))
				pass()
				// TODO: do something
			if(!resolved_entity)
				return null
			for(var/client/C as anything in GLOB.clients)
				var/turf/maybe_turf = get_turf(C.mob)
				var/obj/overmap/entity/maybe_entity = get_overmap_sector(maybe_turf)
				if(maybe_entity == resolved_entity)
					. += C.mob
		if(M_LEVEL)
			var/datum/resolved = target
			var/datum/map_level/resolved_level
			if(istype(resolved, /atom))
				var/turf/maybe_turf = get_turf(resolved)
				if(maybe_turf)
					resolved_level = SSmapping.ordered_levels[maybe_turf.z]
			else if(istype(resolved, /datum/map_level))
				resolved_level = resolved
			for(var/client/C as anything in GLOB.clients)
				var/turf/maybe_turf = get_turf(C.mob)
				if(maybe_turf?.z == resolved_level.z_index)
					. += C.mob
		if(M_RANGE)
			var/atom/resolved = target
			if(!istype(resolved))
				return null
			else
				if(use_los)
					for(var/mob/maybe_viewing in viewers(min(MAX_LOS_RANGE, use_range), resolved))
						if(!maybe_viewing.client)
							continue
						. += maybe_viewing
				else
					var/our_z = get_z(resolved)
					for(var/client/C as anything in GLOB.clients)
						var/mob/maybe_viewing = C.mob
						if((get_z(maybe_viewing) != our_z) || (get_dist(maybe_viewing, resolved) > use_range))
							continue
						if(!maybe_viewing.client)
							continue
						. += maybe_viewing
		if(M_DIRECT)
			var/atom/movable/resolved = target
			if(!istype(resolved))
				return null
			. += resolved.admin_resolve_narrate()
		if(M_LOBBY)
			// do not use client refs directly to prevent gc issues if delayed
			for(var/client/C as anything in GLOB.clients)
				if(isnewplayer(C.mob))
					. += C.mob

/datum/admin_modal/admin_narrate/proc/get_target_data()
	var/datum/resolved = target
	if(!is_target_valid(resolved, mode))
		return null

	var/turf/maybe_turf
	var/datum/map_level/maybe_level
	var/datum/map/maybe_map
	var/obj/overmap/entity/maybe_entity

	if(istype(resolved, /obj/overmap/entity))
		maybe_entity = resolved
	else if(isatom(resolved))
		maybe_turf = get_turf(resolved)
	else if(istype(resolved, /datum/map_level))
		maybe_level = resolved
	else if(istype(resolved, /datum/map))
		maybe_map = resolved

	if(maybe_turf)
		maybe_level = SSmapping.ordered_levels[maybe_turf.z]
		if(maybe_level)
			maybe_map = maybe_level.parent_map
		maybe_entity = get_overmap_sector(maybe_turf)

	. = list()
	if(maybe_turf)
		.["coords"] = list(maybe_turf.x, maybe_turf.y, maybe_turf.z)
	if(maybe_level)
		.["level"] = list("index" = maybe_level.z_index, "name" = maybe_level.name)
	if(maybe_map)
		.["sector"] = list("name" = maybe_map.name)
	if(maybe_entity)
		.["overmap"] = list(
			"name" = maybe_entity.name,
			"x" = maybe_entity.x,
			"y" = maybe_entity.y,
			"map" = maybe_entity.overmap?.name,
		)

/datum/admin_modal/admin_narrate/proc/is_target_valid(datum/target, mode)
	switch(mode)
		if(M_GLOBAL)
			return TRUE
		if(M_LOBBY)
			return TRUE
		if(M_SECTOR)
			return isturf(target) || ismovable(target) || istype(target, /datum/map_level) || istype(target, /datum/map)
		if(M_OVERMAP)
			return isturf(target) || ismovable(target) || istype(target, /datum/map_level) || istype(target, /datum/map)
		if(M_LEVEL)
			return isturf(target) || ismovable(target) || istype(target, /datum/map_level)
		if(M_RANGE)
			return isturf(target) || ismovable(target)
		if(M_DIRECT)
			var/atom/movable/casted = target
			return istype(casted) && casted.admin_resolve_narrate()

/datum/admin_modal/admin_narrate/proc/narrate()
	if(!length(unsafe_raw_html_to_send))
		return
	var/list/mob/targets = resolve_hearers()

	var/emit = unsafe_raw_html_to_send
	var/list/view_target_to_list = list()
	for(var/mob/viewing in targets)
		view_target_to_list += "[key_name(viewing)]"
	tim_sort(view_target_to_list, /proc/cmp_text_asc)
	var/view_target_list = jointext(view_target_to_list, ", ")
	message_admins("[key_name(owner.owner.mob)] sent a [SPAN_TOOLTIP("[html_encode(emit)]", "global narrate")] to [SPAN_TOOLTIP("[view_target_list]", "[length(targets)] target(s)")].")
	log_admin("[key_name(owner.owner.mob)] sent a global narrate to [length(targets)] targets; VIEWERS: '[view_target_list]'', TEXT: '[emit]'")

	for(var/mob/viewing in targets)
		to_chat(viewing, emit)

/datum/admin_modal/admin_narrate/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("setOutput")
			unsafe_raw_html_to_send = params["target"]
			return TRUE
		if("setRange")
			use_range = params["target"]
			if(use_los)
				use_range = clamp(use_range, 0, MAX_LOS_RANGE)
			else
				use_range = clamp(use_range, 0, MAX_ANY_RANGE)
			return TRUE
		if("setMode")
			mode = params["mode"]
			return TRUE
		if("setLos")
			use_los = !!params["target"]
			if(use_los)
				use_range = clamp(use_range, 0, MAX_LOS_RANGE)
			else
				use_range = clamp(use_range, 0, MAX_ANY_RANGE)
			return TRUE
		if("narrate")
			if(params["html"])
				unsafe_raw_html_to_send = params["html"]
			narrate()
			qdel(src)
			return TRUE
		if("cancel")
			qdel(src)
			return TRUE
		if("preview")
			var/emit = params["html"]
			var/list/mob/targets = resolve_hearers()
			var/list/rendered_viewers_list = list()
			for(var/mob/target as anything in targets)
				rendered_viewers_list += "[target.name][target.real_name != target.name ? " ([target.real_name])" : ""]"
			tim_sort(rendered_viewers_list, /proc/cmp_text_asc)
			var/rendered_viewers = jointext(rendered_viewers_list, "<br>")
			var/list/html = list(
				"<hr>",
				SPAN_BLOCKQUOTE(emit, null),
				"<hr>",
				"<center>[SPAN_ADMIN("^^^ Narrate Preview; [length(rendered_viewers) ? SPAN_TOOLTIP(rendered_viewers, "Viewers..."): "No Viewers!"] ^^^")]</center>",
			)
			to_chat(owner.owner, jointext(html, ""))
			return TRUE

/datum/admin_modal/admin_narrate/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "admin_modal/AdminNarrate")
		ui.open()

/datum/admin_modal/admin_narrate/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	// UI-authoritative, so this is only even sent to server
	// to keep the UI persistent across reconnects.
	.["rawHtml"] = unsafe_raw_html_to_send
	.["visualColor"] = narrate_visual_color
	.["possibleModes"] = resolve_modes()

/datum/admin_modal/admin_narrate/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	// This however needs to update
	.["target"] = get_target_data()
	.["mode"] = mode
	.["useLos"] = use_los
	.["useRange"] = use_range
	.["maxRangeLos"] = MAX_LOS_RANGE
	.["maxRangeAny"] = MAX_ANY_RANGE
