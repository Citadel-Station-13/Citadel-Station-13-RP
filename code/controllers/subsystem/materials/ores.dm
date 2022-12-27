/datum/controller/subsystem/materials
	/// ore datums by id
	var/list/ore_lookup

/datum/controller/subsystem/materials/Initialize(start_timeofday)
	initialize_ores()
	verify_ore_datums()
	return ..()

/datum/controller/subsystem/materials/Recover()
	. = ..()
	ore_lookup = SSmaterials.ore_lookup
	verify_ore_datums()

/datum/controller/subsystem/materials/proc/initialize_ores()
	for(var/path in subtypesof(/datum/ore))
		var/datum/ore/O = path
		if(initial(O.abstract_type) == path)
			continue
		O = new path
		ores_by_type[O.id] = O

/datum/controller/subsystem/materials/proc/verify_ore_datums()
	#warn this needs to be a unit test
	if(!islist(ore_lookup))
		subsystem_failure_log("ore lookup wasn't a list")
		ore_lookup = list()
	// get rid of dupes
	var/list/copy = list()
	for(var/id in ore_lookup)
		copy |= id
	if(copy.len != ore_lookup.len)
		subsystem_failure_log("[ore_lookup.len - copy.len] dupes detected and removed")
		for(var/id in copy)
			copy[id] = ore_lookup[id]
		ore_lookup = copy
	for(var/id in ore_lookup)
		if(!istext(id))
			subsystem_failure_log("invalid id [id] as ore id")
			ore_lookup -= id
		if(!istype(ore_lookup[id], /datum/ore))
			subsystem_failure_log("invalid ore datum on [id]")
			ore_lookup -= id

/**
 * fetches ore datum
 *
 * accepts either an id or a path
 */
/datum/controller/subsystem/materials/proc/get_ore(datum/ore/id_or_path)
	if(ispath(id_or_path))
		return ore_lookup[initial(id_or_path.id)]
	return ore_lookup[id_or_path]

/datum/controller/subsystem/materials/proc/register_ore(datum/ore/O)
	ASSERT(initialized)
	ASSERT(!ore_lookup[O.id])
	ore_lookup[O.id] = O

/datum/controller/subsystem/materials/proc/instantiate_ore(id_or_path, atom/where, amount = 1)
	var/datum/ore/O = get_ore(id_or_path)
	O.create_ore(where, amount)
