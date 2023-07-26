//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Manages character setup, character saving, loading,
 * and will eventually serve as the middleware
 * between character preferences and character
 * persistence as well.
 */
SUBSYSTEM_DEF(characters)
	name = "Characters"
	init_order = INIT_ORDER_CHARACTERS
	priority = FIRE_PRIORITY_CHARACTERS
	subsystem_flags = SS_BACKGROUND
	wait = 1 SECOND
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/list/prefs_awaiting_setup = list()
	var/list/preferences_datums = list()
	var/list/newplayers_requiring_init = list()

	var/list/save_queue = list()

/datum/controller/subsystem/characters/Initialize()
	rebuild_caches()
	for(var/ckey in GLOB.preferences_datums)
		var/datum/preferences/P = GLOB.preferences_datums[ckey]
		if(!istype(P))
			stack_trace("what?")
			continue
		P.Initialize()
	return ..()

/datum/controller/subsystem/characters/Recover()
	. = ..()
	rebuild_caches()

/datum/controller/subsystem/characters/proc/rebuild_caches()
	rebuild_species()
	rebuild_languages()
	rebuild_character_species()
	rebuild_backgrounds()

/datum/controller/subsystem/characters/fire(resumed)
	while(save_queue.len)
		var/datum/preferences/prefs = save_queue[save_queue.len]
		save_queue.len--

		if(!QDELETED(prefs))
			prefs.save_preferences()

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/characters/proc/queue_preferences_save(datum/preferences/prefs)
	save_queue |= prefs
