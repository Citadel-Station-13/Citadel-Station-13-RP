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

/*
/datum/controller/subsystem/characters/Initialize()
	while(prefs_awaiting_setup.len)
		var/datum/preferences/prefs = prefs_awaiting_setup[prefs_awaiting_setup.len]
		prefs_awaiting_setup.len--
		prefs.setup()
	while(newplayers_requiring_init.len)
		var/mob/new_player/new_player = newplayers_requiring_init[newplayers_requiring_init.len]
		newplayers_requiring_init.len--
		new_player.deferred_login()
	. = ..()
*/	//Might be useful if we ever switch to Bay prefs.
/datum/controller/subsystem/characters/fire(resumed = FALSE)
	while(save_queue.len)
		var/datum/preferences/prefs = save_queue[save_queue.len]
		save_queue.len--

		if(!QDELETED(prefs))
			prefs.save_preferences()

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/characters/proc/queue_preferences_save(var/datum/preferences/prefs)
	save_queue |= prefs


