/**
 * manages game faction datums
 * 
 * while jobs/departments does rely on this system, factions do not necessarily have to be playable.
 * therefore, this is a separate subsystem that's initialized before jobs.
 * 
 * some factions are only loaded in on certain maps.
 * 
 * todo: jobs don't load without faction being there. maploader --> factions --> jobs --> atoms
 * todo: factions loading in late should enable departments/jobs as needed.
 */
SUBSYSTEM_DEF(factions)
	name = "Factions"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_FACTIONS

	/// all factions by id
	var/list/faction_lookup = list()

/datum/controller/subsystem/factions/Initialize()
	initialize_factions()
	return ..()

/datum/controller/subsystem/factions/Recover()
	if(isnull(SSfactions))
		..()
		return FALSE
	. = ..()
	if(islist(SSfactions.faction_lookup))
		faction_lookup = SSfactions.faction_lookup
		for(var/id in faction_lookup)
			if(!id)
				faction_lookup -= id
				. = FALSE
			var/datum/faction/faction = faction_lookup[id]
			if(!istype(faction))
				faction_lookup -= id
				. = FALSE
	else
		. = FALSE

/datum/controller/subsystem/factions/proc/initialize_factions()
	if(islist(faction_lookup))
		QDEL_LIST(faction_lookup)
	faction_lookup = list()
	for(var/datum/faction/path as anything in subtypesof(/datum/faction))
		if(path == initial(path.abstract_type))
			continue
		if(initial(path.lazy))
			continue
		var/datum/faction/F = new path
		if(!F.register())
			qdel(F)

/**
 * gets a faction if it exists and is loaded
 */
/datum/controller/subsystem/factions/proc/fetch_faction(datum/faction/id_or_path)
	if(ispath(id_or_path))
		var/translating = initial(id_or_path.identifier)
		id_or_path = translating
	return faction_lookup[translating]

/**
 * gets a faction, loading it if it isn't already
 */
/datum/controller/subsystem/factions/proc/load_faction(datum/faction/id_or_path)
	if(ispath(id_or_path))
		var/translating = initial(id_or_path.identifier)
		if(isnull(faction_lookup[translating]) && initial(id_or_path.lazy))
			var/datum/faction/creating = new id_or_path
			creating.register()
		id_or_path = translating
	return faction_lookup[translating]
