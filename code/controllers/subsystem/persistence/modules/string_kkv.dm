//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * String KKV module
 *
 * this is the "generic store anything by key/value" system
 * group specific string load is allowed but not required.
 *
 * use if none of the others can work
 * or if you're somehow too lazy to optimize your persistence system by making a new persistence type
 * but somehow not lazy enough to optimize it into a string??
 *
 * notice how we can't delete strings?
 * that's intentional, and for optimization.
 *
 * string KKV does not currently allow for generations, because generations is a map concept, and this
 * is more of a general system. if you require generations, it can be added later. i just do not really
 * foresee a usage for it yet; even if we needed full-state map serialization, the map systems should
 * handle that instead.
 */
/datum/controller/subsystem/persistence

//* Get / Set *//

/**
 * gets a persistent string
 *
 * given this proc is for advanced users, it will not hold your hand on what group to use. figure it out.
 * prefer SSpersistence for id lookups, not SSmapping, as it's outside of SSmapping's concerns to resolve that.
 *
 * @params
 * - key - key of string
 * - group - optional group-specific. null counts as its own group.
 */
/datum/controller/subsystem/persistence/proc/string_kkv_get(key, group)
	return string_kkv_load(group, key)

/**
 * sets a persistent string
 *
 * given this proc is for advanced users, it will not hold your hand on what group to use. figure it out.
 * prefer SSpersistence for id lookups, not SSmapping, as it's outside of SSmapping's concerns to resolve that.
 *
 * @params
 * - key - key of string
 * - value - string to set it to
 * - group - optional group-specific. null counts as its own group.
 * - flush - immediately invoke SQL; otherwise subsystem decides when.
 */
/datum/controller/subsystem/persistence/proc/string_kkv_set(key, value, group, flush)
	string_kkv_save(group, key, value)

//* Backend Save/Load *//
//! Why the usr fuckery? Because we intentionally wish to obfuscate admin proccalls, since we properly sanitize **everything** in these procs.

/datum/controller/subsystem/persistence/proc/string_kkv_load(group = PERSISTENCE_DEFAULT_NULL_GROUP, key)
	if(!SSdbcore.Connect())
		return
	var/oldusr = usr
	usr = null
	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT `value` FROM [DB_PREFIX_TABLE_NAME("persistence_string_kkv")] WHERE `group` = :group AND `key` = :key",
		list(
			"group" = group,
			"key" = key
		)
	)
	query.Execute(FALSE)
	usr = oldusr
	if(!query.NextRow())
		return
	. = query.item[1]
	qdel(query)

/datum/controller/subsystem/persistence/proc/string_kkv_save(group = PERSISTENCE_DEFAULT_NULL_GROUP, key, value)
	if(!SSdbcore.Connect())
		return
	var/oldusr = usr
	usr = null
	var/datum/db_query/query = SSdbcore.NewQuery(
		"INSERT INTO [DB_PREFIX_TABLE_NAME("persistence_string_kkv")] (`group`, `key`, `value`) VALUES (:group, :key, :value) ON DUPLICATE KEY UPDATE `value` = VALUES(`value`), `modified` = Now(), `revision` = `revision` + 1",
		list(
			"group" = group,
			"key" = key,
			"value" = value
		)
	)
	query.Execute(FALSE)
	usr = oldusr
	qdel(query)

//* Benchmarks *//

/datum/controller/subsystem/persistence/proc/benchmark_string_kkv()
	var/oldusr = usr
	usr = null
	message_admins("SSpersist: benchmarking string storage")
	var/amt = 10000
	var/list/pointer = list(amt)
	var/list/keys = list()
	var/list/values = list()
	for(var/i in 1 to amt)
		keys += "[rand(1, 10000000)]"
		values += "[rand(1, 100000000000000)]"
	var/start = REALTIMEOFDAY
	kkv_string_save_benchmark(pointer, keys, values, amt)
	UNTIL(pointer[1] == 0)
	var/end = REALTIMEOFDAY
	message_admins("SSpersist: saving [amt] strings took [end - start] ds")
	pointer = list(amt)
	start = REALTIMEOFDAY
	kkv_string_load_benchmark(pointer, keys, amt)
	UNTIL(pointer[1] == 0)
	end = REALTIMEOFDAY
	message_admins("SSpersist: loading [amt] strings took [end - start] ds")
	usr = oldusr

/datum/controller/subsystem/persistence/proc/kkv_string_save_benchmark(list/pointer, list/keys, list/values, amt)
	set waitfor = FALSE
	for(var/i in 1 to amt)
		kkv__string_save_benchmark(pointer, keys[i], values[i])

/datum/controller/subsystem/persistence/proc/kkv_string_load_benchmark(list/pointer, list/keys, amt)
	set waitfor = FALSE
	for(var/i in 1 to amt)
		kkv__string_load_benchmark(pointer, keys[i])

/datum/controller/subsystem/persistence/proc/kkv__string_save_benchmark(list/pointer, key, value)
	string_kkv_save("benchmark", key, value)
	pointer[1]--

/datum/controller/subsystem/persistence/proc/kkv__string_load_benchmark(list/pointer, key)
	string_kkv_load("benchmark", key)
	pointer[1]--
