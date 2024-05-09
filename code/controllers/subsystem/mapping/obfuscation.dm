//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Obfuscation module
 *
 * * Generates **mangled** IDs; these are either persistently-unique or round-local IDs that are separate per map / map template.
 * * Generates **obfuscated** IDs; these are mangled and obfuscated IDs that are safe to reveal to players.
 *
 * Mangling keys are based on the **load instance** the mapping subsystem is in.
 * * It is crucial to call these ID transformation procs during preloading_instance(), not Initialize().
 * * It is usually already too late by the time Initialize() fires.
 * * By default, /datum/map (not /datum/map_level), /datum/map_template, /datum/shuttle_template are the three things that form new mangling boundaries/contexts.
 */
/datum/controller/subsystem/mapping
	/// round ID prepend, used to ensure global-ness
	var/static/round_global_descriptor
	/// round-local hash storage for specific map ids
	var/static/round_local_mangling_cache = list()
	/// round-local hash storage for specific map ids, reverse lookup
	var/static/round_local_mangling_reverse_cache = list()

/**
 * Called at init first thing to setup mangling data
 */
/datum/controller/subsystem/mapping/proc/init_obfuscation_data()
	// use either round ID or realtime
	// no chance of collisions
	#warn make this more readable like padded hex or something
	round_global_descriptor = GLOB.round_id ? "[GLOB.round_id]" : "[num2hex(world.realtime)]"

/**
 * Get a short hash for a map specific ID.
 * This operates off the fact that we won't possibly have more than a few thousand maps loaded, as otherwise collisions get bad.
 * The hash is 5 digit hex just in case.
 */
/datum/controller/subsystem/mapping/proc/hash_for_mangling_id(id)
	if(isnull(round_local_mangling_cache[id]))
		// generate hash
		var/increment = 0
		var/generated
		do
			generated = "[id][increment++]"
			// 5 characters
			generated = copytext(md5(generated), 1, 6)
		while(round_local_mangling_reverse_cache[generated])
		round_local_mangling_cache[id] = generated
		round_local_mangling_reverse_cache[generated] = id
	return round_local_mangling_cache[id]

/**
 * This must be called in **preloading_instance()**, not Initialize(), unlike what usual ss13 init logic says.
 *
 * * This is a direct maploader hook to generate a mangled (not obfuscated) ID.
 * * This will be unique to the load instance it's being called from.
 * * This is not globally (cross-round) unique.
 * * This generates human-readable IDs
 * * This does not generate IDs that should be player accessible.
 *
 * @params
 * * id - original id
 * * with_mangling_id - mangling id provided to preloading_instance()
 */
/datum/controller/subsystem/mapping/proc/mangled_round_local_id(id, with_mangling_id)
	if(!id)
		return id
	return "[hash_for_mangling_id(with_mangling_id)]-[id]"

/**
 * This must be called in **preloading_instance()**, not Initialize(), unlike what usual ss13 init logic says.
 *
 * * This is a direct maploader hook to generate a mangled (not obfuscated) ID.
 * * This will be unique to the load instance it's being called from.
 * * This will be globally (cross-round) unique.
 * * This generates human-readable IDs
 * * This does not generate IDs that should be player accessible.
 *
 * @params
 * * id - original id
 * * with_mangling_id - mangling id provided to preloading_instance()
 */
/datum/controller/subsystem/mapping/proc/mangled_persistent_id(id, with_mangling_id)
	if(!id)
		return id
	return "[round_global_descriptor]-[hash_for_mangling_id(with_mangling_id)]-[id]"

/**
 * Generates an obfuscated ID.
 *
 * * This is not globally (cross-round) unique.
 * * This does not necessarily generate human-readable IDs
 * * This generates IDs that may be player accessible.
 * * Better results are obtained by calling this in preloading_instance(), but it is not mandatory.
 * * This only mangles the ID if called with_mangling_id in preloading_instance. Please be aware of that.
 *
 * @params
 * * id - original id
 * * key - provide a custom key to provide separation from other ids, if needed.
 * * with_mangling_id - provide the mangling id if being called in preloading_instance()
 */
/datum/controller/subsystem/mapping/proc/obfuscated_round_local_id(id, key, with_mangling_id)
	if(!id)
		return id
	// todo: optimize; md5 is a bit long.
	// todo: collision checks.
	#warn redo
	return md5(id)

/**
 * Generates an obfuscated ID.
 *
 * * This will be globally (cross-round) unique.
 * * This does not necessarily generate human-readable IDs
 * * This generates IDs that may be player accessible.
 * * Better results are obtained by calling this in preloading_instance(), but it is not mandatory.
 * * This only mangles the ID if called with_mangling_id in preloading_instance. Please be aware of that.
 *
 * @params
 * * id - original id
 * * key - provide a custom key to provide separation from other ids, if needed.
 * * with_mangling_id - provide the mangling id if being called in preloading_instance()
 */
/datum/controller/subsystem/mapping/proc/obfuscated_persistent_id(id, key, with_mangling_id)
	if(!id)
		return id
	// todo: optimize; md5 is a bit long.
	// todo: collision checks.
	#warn redo
	return "[round_global_descriptor]-[md5(id)]"
