// TODO: file unticked
// see [code/datums/prototype.dm] for why.

/**
 * global singleton storage and fetcher
 */
SUBSYSTEM_DEF(repository)
	name = "Repository"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_REPOSITORY

	/// by-type lookup
	var/list/type_lookup
	/// by-id lookup
	var/list/uid_lookup
	/// fetched subtype lists
	var/list/subtype_lists

/datum/controller/subsystem/repository/Initialize()
	uid_lookup = list()
	type_lookup = list()
	subtype_lists = list()
	generate()
	return ..()

/datum/controller/subsystem/repository/Recover()
	. = ..()
	src.type_lookup = SSrepository.type_lookup
	if(!islist(src.type_lookup))
		src.type_lookup = list()
		. = FALSE
	src.uid_lookup = SSrepository.uid_lookup
	if(!islist(src.uid_lookup))
		src.uid_lookup = list()
		. = FALSE

/**
 * prototypes returned should generally not be modified.
 * prototypes returned from a typepath input should never, ever be modified.
 */
/datum/controller/subsystem/repository/proc/fetch(datum/prototype/type_or_id)
	if(isnull(type_or_id))
		return
	if(istext(type_or_id))
		return uid_lookup[type_or_id]
	. = type_lookup[type_or_id]
	if(.)
		return
	// types are complicated, is it lazy?
	if(initial(type_or_id.lazy))
		// if so, init it
		register_internal((. = new type_or_id), TRUE, TRUE)
	else
		CRASH("failed to fetch a hardcoded prototype")

/**
 * lists returned should never, ever be modified.
 * this fetches subtypes, not the first type on purpose.
 */
/datum/controller/subsystem/repository/proc/fetch_subtypes(path)
	RETURN_TYPE(/list)
	ASSERT(ispath(path, /datum/prototype))
	if(subtype_lists[path])
		return subtype_lists[path]
	var/list/generating = list()
	subtype_lists[path] = generating
	for(var/fetching as anything in subtypesof(path))
		var/datum/prototype/instance = fetch(fetching)
		generating += instance
	return generating

/datum/controller/subsystem/repository/proc/register(datum/prototype/instance, force)
	return register_internal(instance, force, FALSE)

/datum/controller/subsystem/repository/proc/register_internal(datum/prototype/instance, force, hardcoded)
	PRIVATE_PROC(TRUE)
	if(uid_lookup[instance] && !force)
		return FALSE
	uid_lookup[instance] = instance
	if(hardcoded)
		type_lookup[instance.type] = instance
	return TRUE

/datum/controller/subsystem/repository/proc/unregister(datum/prototype/instance)
	if(type_lookup[instance.type] == instance)
		CRASH("tried to unregister a hardcoded instance")
	if(!instance.unregister())
		CRASH("instance refused to unregister. this is undefined behavior.")
	uid_lookup -= instance.uid
	return TRUE

/**
 * regenerates entries, kicking out anything that's in the way
 */
/datum/controller/subsystem/repository/proc/generate()
	for(var/datum/prototype/instance as anything in subtypesof(/datum/prototype))
		if(initial(instance.abstract_type) == instance)
			continue
		if(initial(instance.lazy))
			continue
		instance = new instance
		register_internal(instance, TRUE, TRUE)
