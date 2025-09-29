//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/admin_modal/admin_narrate

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
	var/datum/weakref/target_weakref

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

	/// our identifying color
	var/narrate_visual_color

#warn impl

/datum/admin_modal/admin_narrate/Initialize(atom/target)
	. = ..()
	if(!.)
		return
	src.target_weakref = WEAKREF(target)
	src.narrate_visual_color = rgb(arglist(hsl2rgb(rand(0, 360), rand(0, 360), rand(125, 360))))

	var/list/possible_modes = resolve_modes()
	if(length(possible_modes))
		src.mode = possible_modes[1]
	else
		return FALSE

/datum/admin_modal/admin_narrate/Destroy()
	target_weakref = null

/**
 * @return list of M_ modes
 */
/datum/admin_modal/admin_narrate/proc/resolve_modes()
	var/datum/resolved = target_weakref?.resolve()
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
		. += /datum/admin_modal/admin_narrate::M_LEVEL
		. += /datum/admin_modal/admin_narrate::M_RANGE
		. += /datum/admin_modal/admin_narrate::M_SECTOR
		. += /datum/admin_modal/admin_narrate::M_OVERMAP
		if(ismovable(resolved))
			var/atom/movable/casted = resolved
			if(casted.admin_resolve_narrate())
				// compatible with direct-narrate
				. += /datum/admin_modal/admin_narrate::M_DIRECT
	else if(istype(resolved, /datum/map_level))
		. += /datum/admin_modal/admin_narrate::M_SECTOR
		. += /datum/admin_modal/admin_narrate::M_LEVEL
		// TODO: check for overmap binding & add overmap if it's there
	else if(istype(resolved, /datum/map))
		. += /datum/admin_modal/admin_narrate::M_SECTOR
		// TODO: check for overmap binding & add overmap if it's there

/**
 * @return list of mobs, or null if invalid
 */
/datum/admin_modal/admin_narrate/proc/resolve_hearers()
	. = list()
	switch(mode)
		if(M_GLOBAL)
			// do not use client refs directly to prevent gc issues if delayed
			for(var/client/C as anything in GLOB.clients)
				. += C.mob
		if(M_SECTOR)
			var/atom/resolved = target_weakref.resolve()
			#warn impl
		if(M_OVERMAP)
			var/atom/resolved = target_weakref.resolve()
			var/obj/overmap/entity/resolved_entity
			if(istype(resolved, /obj/overmap/entity))
				resolved_entity = resolved
			#warn impl
		if(M_LEVEL)
			var/atom/resolved = target_weakref.resolve()
			#warn impl
		if(M_RANGE)
			var/atom/resolved = target_weakref.resolve()
			#warn impl
		if(M_DIRECT)
			var/atom/resolved = target_weakref.resolve()
			#warn impl
		if(M_LOBBY)
			// do not use client refs directly to prevent gc issues if delayed
			for(var/client/C as anything in GLOB.clients)
				if(isnewplayer(C.mob))
					. += C.mob

/datum/admin_modal/admin_narrate/proc/get_target_data()
	var/datum/resolved = target_weakref?.resolve()
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
	var/list/mob/targets = resolve_hearers()
	#warn impl
	#warn log, chat component?

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
			return TRUE
		if("setLos")
			use_los = !!params["target"]
			return TRUE
		if("narrate")
			narrate()
			qdel(src)
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
	.["mode"] = mode
	.["useLos"] = use_los
	.["useRange"] = use_range

/datum/admin_modal/admin_narrate/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	// This however needs to update
	.["target"] = get_target_data()
