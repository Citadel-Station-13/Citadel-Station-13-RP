/**
 * Repository controllers.
 *
 * Storage for prototypes.
 *
 * Allows:
 *
 * * Looking instances up via ID
 * * Looking instances up via typepath (if hardcoded)
 *
 * Should be:
 *
 * * Init order independent. This means that repositories should function
 *   if the database is up even if it hasn't technically initialized yet.
 *   This is because repositories init in an undetermined order (on purpose),
 *   and many repositories may / will depend on others.
 *   As an example, design datums require resolution of material datums.
 */
/datum/controller/repository
	abstract_type = /datum/controller/repository
	name = "REPOSITORY OF SOME KIND"

	/// expected type of prototype
	var/expected_type

	/// by-id lookup
	var/list/id_lookup
	/// by-type lookup
	var/list/type_lookup

	/// fetched subtype lists
	var/tmp/list/subtype_lists

/datum/controller/repository/Initialize()
	id_lookup = list()
	type_lookup = list()
	subtype_lists = list()
	generate()
	return ..()

/**
 * Repository Recover()
 *
 * The old instance is passed in.
 * You can, and should, cast it to the type you're defining this on, as it'll always be the same type.
 */
/datum/controller/repository/Recover(datum/controller/repository/old_instance)
	. = ..()
	if(!istype(old_instance))
		src.type_lookup = list()
		src.id_lookup = list()
		src.subtype_lists = list()
		generate()
		return FALSE
	src.type_lookup = old_instance.type_lookup
	if(!islist(src.type_lookup))
		src.type_lookup = list()
		. = FALSE
	src.id_lookup = old_instance.id_lookup
	if(!islist(src.id_lookup))
		src.id_lookup = list()
		. = FALSE
	src.subtype_lists = list()

/**
 * regenerates entries, kicking out anything that's in the way
 */
/datum/controller/repository/proc/generate()
	for(var/datum/prototype/instance as anything in subtypesof(expected_type))
		if(initial(instance.abstract_type) == instance)
			continue
		if(initial(instance.lazy))
			continue
		instance = new instance
		instance.hardcoded = TRUE
		load(instance)

//* Public API *//

/**
 * Fetches a prototype by type or ID.
 *
 * * Allows passing in a prototype instance which will be returned as itself.
 *   Useful for procs that should accept types, IDs, *and* instances.
 *
 * prototypes returned should never, ever be modified
 *
 * @return prototype instance or null
 */
/datum/controller/repository/proc/fetch(datum/prototype/type_or_id)
	// todo: optimize
	if(isnull(type_or_id))
		return
	else if(istype(type_or_id))
		return type_or_id
	else if(ispath(type_or_id))
		. = type_lookup[type_or_id]
		if(.)
			return
		// types are complicated, is it lazy?
		if(initial(type_or_id.lazy) && (initial(type_or_id.abstract_type) != type_or_id))
			// if so, init it
			var/datum/prototype/loading = new type_or_id
			loading.hardcoded = TRUE
			load(instance)
		else
			CRASH("failed to fetch a hardcoded prototype")
	else if(istext(type_or_id))
		return id_lookup[type_or_id]
	else
		CRASH("what?")

/**
 * Fetches a list of prototypes by type or ID.
 *
 * * Allows passing in prototype instances which will be returned as itself.
 *   Useful for procs that should accept types, IDs, *and* instances.
 *
 * prototypes returned should never, ever be modified
 *
 * @return list() of instances
 */
/datum/controller/repository/proc/fetch_multi(list/datum/prototype/types_or_ids)
	// todo: optimize
	. = list()
	for(var/datum/prototype/casted as anything in types_or_ids)
		. += fetch(casted)

/**
 * lists returned should never, ever be modified.
 * this fetches subtypes, not the first type on purpose.
 */
/datum/controller/repository/proc/fetch_subtypes(path)
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

/**
 * Registers a prototype created midround.
 *
 * * This can immediately save it to the database.
 * * After calling this, **you must release any cached references to the instance from the calling proc.**
 *   After this call, the repository now owns the instance, not whichever system created it.
 */
/datum/controller/repository/proc/register(datum/prototype/instance)
	return load(instance)

//* Private API *//

/**
 * Registers a prototype with the subsystem.
 *
 * * This is for internal use.
 */
/datum/controller/repository/proc/load(datum/prototype/instance)
	PROTECTED_PROC(TRUE)
	if(id_lookup[instance])
		return FALSE
	id_lookup[instance] = instance
	if(instance.hardcoded)
		// invalidate cache
		// todo: smarter way to do this
		subtype_lists = list()
		type_lookup[instance.type] = instance
	return TRUE

/**
 * Unregister a prototype.
 *
 * * This does not delete it from existence, this just unloads it from the subsystem.
 * * This is for internal use.
 */
/datum/controller/repository/proc/unload(datum/prototype/instance)
	PROTECTED_PROC(TRUE)
	if(type_lookup[instance.type] == instance)
		CRASH("tried to unregister a hardcoded instance")
	if(!instance.unregister())
		CRASH("instance refused to unregister. this is undefined behavior.")
	// invalidate cache
	// todo: smarter way to do this
	subtype_lists = list()
	id_lookup -= instance.id
	return TRUE
