/**
 * Manages character setup, character saving, loading,
 * and will eventually serve as the middleware
 * between character preferences and character
 * persistence as well.
 */
SUBSYSTEM_DEF(characters)
	name = "Characters"
	init_order = INIT_ORDER_DEFAULT
	priority = FIRE_PRIORITY_CHARSETUP
	subsystem_flags = SS_BACKGROUND
	wait = 1 SECOND
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/list/prefs_awaiting_setup = list()
	var/list/preferences_datums = list()
	var/list/newplayers_requiring_init = list()

	var/list/save_queue = list()

	//! Species
	/**
	 * yeah so funny right
	 *
	 * we have a lot of fake-people around (minor races/human reskins)
	 * i can't remove them because that'd ruffle feathers
	 *              ( literally, looking at you harpies )
	 * so **everyone** gets to be a /datum/character_species
	 * that way we get the name, desc, and species id of what
	 * actual species we should be any are able to do roundstart tweaks.
	 */
	var/list/species_lookup = list()

/datum/controller/subsystem/characters/Initialize()
	rebuild_caches()
	return ..()

/datum/controller/subsystem/characters/Recover()
	. = ..()
	rebuild_caches()

/datum/controller/subsystem/characters/proc/rebuild_caches()
	rebuild_species()

/datum/controller/subsystem/characters/proc/rebuild_species()
	species_data = list()
	species_lookup = list()
	species_ui_cache = list()
	species_whitelisted = list()
	#warn impl

/datum/controller/subsystem/characters/proc/resolve_real_species(uid)
	RETURN_TYPE(/datum/character_species)

/datum/controller/subsystem/characters/proc/run_species_tweaks(uid, datum/species/S)
	var/datum/character_species/faux = resolve_real_species(uid)
	if(faux.is_real)
		return			// why tf you using this instead of the species system?


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


