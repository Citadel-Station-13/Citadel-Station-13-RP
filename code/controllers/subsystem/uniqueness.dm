//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Nebula calls this a repository, I call this a subsystem.
 * This is in charge of assigning non-duplicating IDs to things.
 * * Also in charge of round and map mangling.
 */
SUBSYSTEM_DEF(uniqueness)
	name = "Uniqueness"
	subsystem_flags = SS_NO_FIRE | SS_NO_INIT

	/// kkv list
	var/static/list/ids_created = list()

	VAR_PRIVATE/round_notch

	var/list/phrase_generation_fragments

/datum/controller/subsystem/uniqueness/Initialize()
	var/rt_hex = num2hex(world.realtime, 8)
	if(length(rt_hex) != 8)
		stack_trace("rt_hex '[rt_hex]' not 8 characters")
	round_notch = "[copytext(rt_hex, 1, 5)]-[copytext(rt_hex, 5, 9)]"
	var/list/phrasegen_frags = list()
	for(var/str in world.file2list("strings/1000_most_common.txt") + world.file2list("strings/names/verbs.txt"))
		if(length(str) < 5)
			continue
		phrasegen_frags += str
	phrase_generation_fragments = phrasegen_frags
	return ..()

/**
 * Get a value that can be used to 'notch' the round. Other systems
 * that implement their own ID systems have use for this.
 */
/datum/controller/subsystem/uniqueness/proc/get_round_notch()
	if(!initialized)
		CRASH("attempted to get round notch before it was ready")
	return round_notch

/**
 * Relatively expensive. Ideal for things like persistent items if database ID is not avaiable.
 * * Makes no promises about ID format stability.
 * * Created ID is not cryptographic and should be assumed easy to guess by players.
 */
/datum/controller/subsystem/uniqueness/proc/create_uuid()
	return GUID()

/**
 * * Makes no promises about ID format  stability. Surely you aren't storing it anywhere?
 * * Created ID is not cryptographic and should be assumed easy to guess by players.
 *
 * @params
 * * key - category
 */
/datum/controller/subsystem/uniqueness/proc/create_unique_id(key)
	var/list/store = ids_created[key]
	if(!store)
		ids_created[key] = (store = list())
	for(var/desired_length = 5; desired_length < 9; desired_length++)
		var/iterations = desired_length * 20
		for(var/iter = 0; iter < iterations; iter++)
			. = copytext(md5("[rand(1, 99999)][rand(1, 99999)]"), 1, desired_length)
			if(store[.])
			else
				store[.] = TRUE
				return

/**
 * * Makes no promises about ID format stability.
 * * Created ID is not cryptographic and should be assumed easy to guess by players.
 * * Safe to use for persistence. All returned values will always be globally unique.
 *
 * @params
 * * key - category
 */
/datum/controller/subsystem/uniqueness/proc/create_unique_persistent_id(key)
	return "[round_notch]-[create_unique_id(key)]"

/**
 * Gets a mangled ID. The output is the same for a given key, original, and mangling seed.
 * * Makes no promises about ID format stability. Surely you aren't storing it anywhere?
 * * Created ID is not cryptographic and should be assumed easy to guess by players.
 *
 * @params
 * * key - category
 * * original - ID to mangle
 * * seed - mangling seed; for maps, this is generated on the map datum.
 */
// /datum/controller/subsystem/uniqueness/proc/get_mangled_id(key, original, seed)
// TODO: mangling API

/**
 * Gets a mangled ID. The output is the same for a given key, original, and mangling seed.
 * * Makes no promises about ID format stability.
 * * Created ID is not cryptographic and should be assumed easy to guess by players.
 * * Safe to use for persistence. All returned values will always be globally unique.
 *
 * @params
 * * key - category
 * * original - ID to mangle
 * * seed - mangling seed; for maps, this is generated on the map datum.
 */
// /datum/controller/subsystem/uniqueness/proc/get_persistent_mangled_id(key, mangle_with)
// TODO: mangling API

/**
 * Generate a sane random password, with 'passphrase' style
 */
/datum/controller/subsystem/uniqueness/proc/generate_password_phrase(fragments = 5)
	ASSERT(fragments > 0 && fragments < 15)
	var/list/picked = list()
	for(var/i in 1 to fragments)
		picked += pick(phrase_generation_fragments)
	return jointext(picked, "-")

// TODO: generate_password_2000s for BlueJay123! style
// TODO: generate_password_entropic for j4(*$uf4v (unreadable subsmashing) style
