//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

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
	/// database key; this is immutable.
	/// * persistence is disabled if this is not set
	var/database_key
	/// store version
	/// * persistence is disabled if this is not set
	/// * migration is triggered if this doesn't match a loaded entry
	var/store_version

	/// by-id lookup
	var/list/id_lookup
	/// by-type lookup
	var/list/type_lookup

	/// fetched subtype lists
	var/tmp/list/subtype_lists

	/// 'doesn't exist' cache for DB loads
	var/tmp/list/doesnt_exist_cache

	/// temporary id to path lookup used during init
	//  todo: figure out a way to not do this, this is bad
	var/tmp/list/init_reverse_lookup_shim

/datum/controller/repository/proc/Create()
	id_lookup = list()
	type_lookup = list()
	subtype_lists = list()
	init_reverse_lookup_shim = list()
	doesnt_exist_cache = list()
	for(var/datum/prototype/casted as anything in subtypesof(expected_type))
		if(initial(casted.abstract_type) == casted)
			continue
		var/casted_id = initial(casted.id)
		if(!casted_id)
			continue
		init_reverse_lookup_shim[casted_id] = casted
	return TRUE

/datum/controller/repository/Initialize()
	generate()
	init_reverse_lookup_shim = null
	return ..()

/**
 * Repository Recover()
 *
 * The old instance is passed in.
 * You can, and should, cast it to the type you're defining this on, as it'll always be the same type.
 */
/datum/controller/repository/Recover(datum/controller/repository/old_instance)
	// todo: redo recover logic; maybe /datum/controller as a whole should be brushed up
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
		// are we already loaded?
		if(type_lookup[instance])
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
/datum/controller/repository/proc/fetch(datum/prototype/type_or_id) as /datum/prototype
	RETURN_TYPE(/datum/prototype)
	// todo: optimize
	if(isnull(type_or_id))
		return
	else if(istext(type_or_id))
		if(init_reverse_lookup_shim)
			var/potential_path = init_reverse_lookup_shim[type_or_id]
			return fetch(potential_path)
		return id_lookup[type_or_id] || handle_db_load(type_or_id)
	else if(ispath(type_or_id))
		. = type_lookup[type_or_id]
		if(.)
			return
		if(initial(type_or_id.abstract_type) == type_or_id)
			CRASH("tried to fetch an abstract prototype")
		var/datum/prototype/loading = new type_or_id
		loading.hardcoded = TRUE
		load(loading)
		return loading
	else if(istype(type_or_id))
		return type_or_id
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
/datum/controller/repository/proc/fetch_subtypes_immutable(path) as /list
	RETURN_TYPE(/list)
	ASSERT(ispath(path, /datum/prototype))
	if(subtype_lists[path])
		return subtype_lists[path]
	var/list/generating = list()
	subtype_lists[path] = generating
	for(var/datum/prototype/casted as anything in subtypesof(path))
		if(initial(casted.abstract_type) == casted)
			continue
		var/datum/prototype/instance = fetch(casted)
		generating += instance
	return generating

/**
 * lists returned may be modified
 */
/datum/controller/repository/proc/fetch_subtypes_mutable(path) as /list
	RETURN_TYPE(/list)
	return fetch_subtypes_immutable(path).Copy()

/**
 * Registers a prototype created midround.
 *
 * * This can immediately save it to the database.
 * * After calling this, **you must release any cached references to the instance from the calling proc.**
 *   After this call, the repository now owns the instance, not whichever system created it.
 */
/datum/controller/repository/proc/register(datum/prototype/instance)
	. = load(instance)
	if(!.)
		return
	handle_db_store(instance)

//* Private API *//

/**
 * Registers a prototype with the subsystem.
 *
 * * This is for internal use.
 */
/datum/controller/repository/proc/load(datum/prototype/instance)
	PROTECTED_PROC(TRUE)
	if(id_lookup[instance])
		. = FALSE
		CRASH("attempted to load an instance that collides with a currently loaded instance on ID.")
	if(instance.hardcoded && type_lookup[instance.type])
		. = FALSE
		CRASH("attempted to load an instance that collides with a currently loaded instance on type.")
	if(!instance.register())
		. = FALSE
		CRASH("instance refused to unregister. this is undefined behavior.")
	id_lookup[instance.id] = instance
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
	if(!instance.unregister())
		. = FALSE
		CRASH("instance refused to unregister. this is undefined behavior.")
	id_lookup -= instance.id
	if(instance.hardcoded)
		// invalidate cache
		// todo: smarter way to do this
		subtype_lists = list()
		type_lookup -= instance.type
	return TRUE

/**
 * Perform migration on a data-list from the database.
 *
 * * Edit the passed in list directly.
 */
/datum/controller/repository/proc/migrate(list/modifying, from_version)
	PROTECTED_PROC(TRUE)

/datum/controller/repository/proc/handle_db_store(datum/prototype/instance)
	if(!Configuration.get_entry(/datum/toml_config_entry/backend/repository/persistence))
		return
	doesnt_exist_cache -= instance.id

/datum/controller/repository/proc/handle_db_load(instance_id)
	if(doesnt_exist_cache[instance_id])
		return

	var/const/doesnt_exist_cache_trim_at = 1000
	var/const/doesnt_exist_cache_trim_to = 500
	if(!Configuration.get_entry(/datum/toml_config_entry/backend/repository/persistence))
		doesnt_exist_cache[instance_id] = TRUE
		if(length(doesnt_exist_cache) > doesnt_exist_cache_trim_at)
			doesnt_exist_cache.len = doesnt_exist_cache_trim_to
		return


#warn impl
