//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Obfuscation module
 *
 * todo: should this be mapping? this is a lot more important than just mapping
 *
 * * Generates **mangled** IDs; these are either persistently-unique or round-local IDs that are separate per map / map template.
 * * Generates **obfuscated** IDs; these are mangled and obfuscated IDs that are safe to reveal to players.
 *
 * Mangling keys are based on the **load instance** the mapping subsystem is in.
 * * It is crucial to call these ID transformation procs during preloading_from_mapload(), not Initialize().
 * * It is usually already too late by the time Initialize() fires.
 * * By default, /datum/map (not /datum/map_level), /datum/map_template, /datum/shuttle_template are the three things that form new mangling boundaries/contexts.
 */

/**
 * Called at init first thing to setup mangling data
 */
/datum/controller/subsystem/mapping/proc/init_obfuscation_data()
	// no (real) chance of collisions
	var/hex_string = "[num2hex(world.realtime)]"
	var/list/built = list()
	for(var/i in 1 to ceil(length(hex_string) / 4))
		built += copytext(hex_string, 1 + (i - 1) * 4, 1 + (i) * 4)
	round_global_descriptor = jointext(built, "-")

/**
 * Get a short hash for a map specific ID.
 */
/datum/controller/subsystem/mapping/proc/hash_for_mangling_id(id, short)
	if(isnull(round_local_mangling_cache[id]))
		// generate hash
		var/increment = 0
		var/generated
		do
			generated = "[id][increment++]"
			if(short)
				// 4 characters; short is usually used when we'll be mangled with a round-global id anyways,
				// which provides a massive amount of collision / guesswork resistance
				// (in theory; players can always guess for current round)
				// (you aren't using round-global ids for no good reason, right?)
				generated = copytext(md5(generated), 1, 5)
			else
				// 8 characters - we only need 4 to realistically be low-collision,
				// but it's this long to prevent players from being funny and guessing shit
				generated = copytext(md5(generated), 1, 9)
				// "1234-5678" it just to be pretty
				generated = "[copytext(generated, 1, 5)]-[copytext(generated, 5, 9)]"
		while(round_local_mangling_reverse_cache[generated] || round_local_obfuscation_reverse_cache[generated])
		round_local_mangling_cache[id] = generated
		round_local_mangling_reverse_cache[generated] = id
	return round_local_mangling_cache[id]

/**
 * This must be called in **preloading_from_mapload()**, not Initialize(), unlike what usual ss13 init logic says.
 *
 * * This is a direct maploader hook to generate a mangled (not obfuscated) ID.
 * * This will be unique to the load instance it's being called from.
 * * This is not globally (cross-round) unique.
 * * This generates human-readable IDs
 * * This does not generate IDs that should be player accessible.
 * * This generates IDs with a different namespace than other mangling/obfuscation procs.
 *
 * @params
 * * id - original id
 * * with_mangling_id - mangling id provided to preloading_from_mapload()
 */
/datum/controller/subsystem/mapping/proc/mangled_round_local_id(id, with_mangling_id)
	if(!id)
		return id
	return "[id]-[hash_for_mangling_id(with_mangling_id)]"

/**
 * This must be called in **preloading_from_mapload()**, not Initialize(), unlike what usual ss13 init logic says.
 *
 * * This is a direct maploader hook to generate a mangled (not obfuscated) ID.
 * * This will be unique to the load instance it's being called from.
 * * This will be globally (cross-round) unique.
 * * This generates human-readable IDs
 * * This does not generate IDs that should be player accessible.
 * * This generates IDs with a different namespace than other mangling/obfuscation procs.
 *
 * @params
 * * id - original id
 * * with_mangling_id - mangling id provided to preloading_from_mapload()
 */
/datum/controller/subsystem/mapping/proc/mangled_persistent_id(id, with_mangling_id)
	if(!id)
		return id
	return "[id]-[hash_for_mangling_id(with_mangling_id, TRUE)]-[round_global_descriptor]"

/**
 * Generates an obfuscated ID.
 *
 * * This is not globally (cross-round) unique.
 * * This does not necessarily generate human-readable IDs, but tries its best!
 * * This generates IDs that may be player accessible.
 * * Better results are obtained by calling this in preloading_from_mapload(), but it is not mandatory.
 * * This only mangles the ID if called with_mangling_id in preloading_from_mapload. Please be aware of that.
 * * This generates IDs with a different namespace than other mangling/obfuscation procs.
 *
 * @params
 * * id - original id
 * * with_mangling_id - provide the mangling id if being called in preloading_from_mapload()
 * * with_visible_key - provide and we'll include it at the start so players know what a key is for
 */
/datum/controller/subsystem/mapping/proc/obfuscated_round_local_id(id, with_mangling_id, with_visible_key)
	if(!id)
		return id
	var/cache_key
	if(with_mangling_id)
		var/mangling_hash = hash_for_mangling_id("[with_mangling_id]", TRUE)
		cache_key = "[id]-[mangling_hash]"
	else
		cache_key = "[id]"
	if(isnull(round_local_obfuscation_cache[cache_key]))
		// tl;dr we md5 it again with the id to ensure the level's mangling id isn't accessible directly
		var/generation
		var/notch = 0
		do
			generation = md5("[cache_key]-[notch]")
			generation = "[copytext(generation, 1, 5)]-[copytext(generation, 5, 9)]"
			if(with_visible_key)
				generation = "[with_visible_key]-[generation]"
		while(round_local_obfuscation_reverse_cache[generation] || round_local_mangling_reverse_cache[generation])
		round_local_obfuscation_cache[cache_key] = generation
		round_local_obfuscation_reverse_cache[generation] = cache_key
	return round_local_obfuscation_cache[cache_key]

/**
 * Generates an obfuscated ID.
 *
 * * This will be globally (cross-round) unique.
 * * This does not necessarily generate human-readable IDs, but tries its best!
 * * This generates IDs that may be player accessible.
 * * Better results are obtained by calling this in preloading_from_mapload(), but it is not mandatory.
 * * This only mangles the ID if called with_mangling_id in preloading_from_mapload. Please be aware of that.
 * * This generates IDs with a different namespace than other mangling/obfuscation procs.
 *
 * @params
 * * id - original id
 * * with_mangling_id - provide the mangling id if being called in preloading_from_mapload()
 * * with_visible_key - provide and we'll include it at the start so players know what a key is for
 */
/datum/controller/subsystem/mapping/proc/obfuscated_persistent_id(id, with_mangling_id, with_visible_key)
	if(!id)
		return id
	var/cache_key
	if(with_mangling_id)
		var/mangling_hash = hash_for_mangling_id("[with_mangling_id]", TRUE)
		cache_key = "[id]-[mangling_hash]"
	else
		cache_key = "[id]"
	if(isnull(round_local_obfuscation_cache[cache_key]))
		// tl;dr we md5 it again with the id to ensure the level's mangling id isn't accessible directly
		var/generation
		var/notch = 0
		do
			generation = md5("[cache_key]-[notch]")
			generation = "[copytext(generation, 1, 5)]-[copytext(generation, 5, 9)]"
			if(with_visible_key)
				generation = "[with_visible_key]-[generation]"
			// unsecure, yes, but without a SQL unique lookup we need a verifiable way of ensuring no collision property.
			generation = "[generation]-[round_global_descriptor]"
		while(round_local_obfuscation_reverse_cache[generation] || round_local_mangling_reverse_cache[generation])
		round_local_obfuscation_cache[cache_key] = generation
		round_local_obfuscation_reverse_cache[generation] = cache_key
	return round_local_obfuscation_cache[cache_key]
