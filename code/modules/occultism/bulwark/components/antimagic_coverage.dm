//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/component/antimagic_coverage
	registered_type = /datum/component/antimagic_coverage

	/**
	 * antimagic sources, associated to priority
	 */
	var/list/datum/antimagic/antimagic_sources = list()
	/**
	 * antimagic sources, associated to callback, if a special handler is registered
	 * * callbacks will be executed with (datum/antimagic/source, list/antimagic_args).
	 */
	var/list/datum/antimagic/antimagic_callbacks

/datum/component/antimagic_coverage/proc/add_source(datum/antimagic/source, datum/callback/on_invoke)
	ASSERT(!antimagic_sources[source])
	BINARY_INSERT(source, antimagic_sources, /datum/antimagic, source, priority, COMPARE_KEY)
	antimagic_sources[source] = source.priority
	if(on_invoke)
		LAZYSET(antimagic_callbacks, source, on_invoke)

/datum/component/antimagic_coverage/proc/remove_source(datum/antimagic/source)
	ASSERT(antimagic_sources[source])
	antimagic_sources -= source
	LAZYREMOVE(antimagic_callbacks, source)
	// TODO: auto-qdel-self on a timer if empty

/datum/component/antimagic_coverage/proc/update_source(datum/antimagic/source)
	ASSERT(antimagic_sources[source])
	remove_source(source)
	add_source(source)


#warn impl all

/**
 * @return modified args; access with ANTIMAGIC_ARG_*
 */
/datum/component/antimagic_coverage/proc/antimagic_check(magic_potency, magic_type, list/magic_data, target_zone, efficiency)

