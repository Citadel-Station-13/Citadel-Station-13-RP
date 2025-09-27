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
	var/mode = M_GLOBAL

	/// use line of sight when doing in range?
	var/use_los = FALSE
	/// use range in tiles; in overmaps, this is multiples of WORLD_ICON_SIZE
	var/use_range = 14

#warn impl

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
	else if(isatom(resolved))
		if(ismovable(resolved))
		else if(isturf(resolved))
	else if(istype(resolved, /datum/map_level))
	else if(istype(resolved, /datum/map))
	#warn impl

/**
 * @return list of mobs, or null if invalid
 */
/datum/admin_modal/admin_narrate/proc/resolve_targets()
	switch(mode)
		if(M_GLOBAL)
		if(M_SECTOR)
		if(M_OVERMAP)
		if(M_LEVEL)
		if(M_RANGE)
		if(M_DIRECT)
		if(M_LOBBY)

/datum/admin_modal/admin_narrate/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("setTarget")
		if("setOutput")
		if("setRange")
		if("setLos")
		if("narrate")

/datum/admin_modal/admin_narrate/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/datum/admin_modal/admin_narrate/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/admin_modal/admin_narrate/ui_data(mob/user, datum/tgui/ui)
	. = ..()

#warn log this
#warn tell admins in message admins with a popup tgchat component
