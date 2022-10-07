/**
 * Manages character setup, character saving, loading,
 * and will eventually serve as the middleware
 * between character preferences and character
 * persistence as well.
 */
SUBSYSTEM_DEF(characters)
	name = "Characters"
	init_order = INIT_ORDER_CHARACTERS
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
	var/list/species_lookup
	/**
	 * species ui cache
	 * so we don't rebuild this every time someone makes an ui
	 * list of categories associated to lists
	 * second layer of list contains:
	 * {name: str, desc: str, whitelisted: 1 or 0, id: str}
	 */
	var/list/species_cache
	#warn more

/datum/controller/subsystem/characters/Initialize()
	rebuild_caches()
	return ..()

/datum/controller/subsystem/characters/Recover()
	. = ..()
	rebuild_caches()

/datum/controller/subsystem/characters/proc/rebuild_caches()
	rebuild_species()

/datum/controller/subsystem/characters/proc/rebuild_species()
	// make species lookup
	species_lookup = list()
	for(var/path in GLOB.species_meta)
		var/datum/species/S = GLOB.species_meta[path]
		if(!(S.spawn_flags & SPECIES_CAN_JOIN))		// don't bother lmao
			continue
		if(species_lookup[S.uid])
			stack_trace("species uid collision on [uid] from [S.type].")
			continue
		species_lookup[S.uid] = S.construct_character_species()
	for(var/path in subtypesof(/datum/character_species))
		var/datum/character_species/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		if(species_lookup[S.uid])
			stack_trace("ignoring custom character species path [path] - collides on uid [uid]")
			continue
		species_lookup[S.uid] = S

	// make species data cache
	species_lookup = list()
	for(var/id in species_lookup)
		var/datum/character_species/S = species_lookup[id]
		LAZYINITLIST(species_cache[S.category])
		species_cache[S.category] += list(list(
			"id" = S.uid,
			"whitelisted" = S.whitelisted,
			"name" = S.name,
			"desc" = S.desc
		))

/datum/controller/subsystem/characters/proc/resolve_real_species(uid)
	RETURN_TYPE(/datum/character_species)

/datum/controller/subsystem/characters/proc/run_species_tweaks(uid, datum/species/S)
	var/datum/character_species/faux = resolve_real_species(uid)
	if(faux.is_real)
		return FALSE			// why tf you using this instead of the species system?
	faux.tweak(S)
	return TRUE

/datum/controller/subsystem/characters/proc/construct_species(uid)
	RETURN_TYPE(/datum/species)
	var/datum/character_species/faux = resolve_real_species(uid)
	var/datum/species/built = new faux.real_species_type
	faux.tweak(S)
	return S

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


