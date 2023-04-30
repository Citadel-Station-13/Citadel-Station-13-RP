/**
 * ! Unique String Persistence
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
 */
/datum/controller/subsystem/persistence

/**
 * gets a persistent string
 *
 * @params
 * - key - key of string
 * - group - optional group-specific. null counts as its own group.
 */
/datum/controller/subsystem/persistence/proc/GetString(key, group)
	return LoadString(group, key)

/**
 * sets a persistent string
 *
 * @params
 * - key - key of string
 * - value - string to set it to
 * - group - optional group-specific. null counts as its own group.
 * - flush - immediately invoke SQL; otherwise subsystem decides when.
 */
/datum/controller/subsystem/persistence/proc/SetString(key, value, group, flush)
	SaveString(group, key, value)

/**
 * gets the group name for the current map
 */
//! This segment will be uncommented when maploader rework is done and we have station map IDs.
/*
/datum/controller/subsystem/persistence/proc/_map_string_group()
	PRIVATE_PROC(TRUE)
	return current_map_id? "__map_[current_map_id]" : null

/datum/controller/subsystem/persistence/proc/GetMapString(key)
	var/group = _map_string_group()
	if(!group)
		return
	return GetString(key, group)

/datum/controller/subsystem/persistence/proc/SetMapString(key, value, flush)
	var/group = _map_string_group()
	if(!group)
		return
	return SetString(key, value, group, flush)
*/

//! Why the usr fuckery? Because we intentionally wish to obfuscate admin proccalls, since we properly sanitize **everything** in these procs.

/datum/controller/subsystem/persistence/proc/LoadString(group = OBJECT_PERSISTENCE_GROUP_NONE, key)
	if(!SSdbcore.Connect())
		return
	var/oldusr = usr
	usr = null
	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT `value` FROM [format_table_name("persist_keyed_strings")] WHERE `group` = :group, `key` = :key",
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

/datum/controller/subsystem/persistence/proc/SaveString(group = OBJECT_PERSISTENCE_GROUP_NONE, key, value)
	if(!SSdbcore.Connect())
		return
	var/oldusr = usr
	usr = null
	var/datum/db_query/query = SSdbcore.NewQuery(
		"INSERT INTO [format_table_name("persist_keyed_strings")] (`group`, `key`, `value`) VALUES (:group, :key, :value) ON DUPLICATE KEY UPDATE `value` = VALUES(`value`), `modified` = Now(), `revision` = `revision` + 1",
		list(
			"group" = group,
			"key" = key,
			"value" = value
		)
	)
	query.Execute(FALSE)
	usr = oldusr
	qdel(query)

/datum/controller/subsystem/persistence/proc/benchmark_strings()
	var/oldusr = usr
	usr = null
	message_admins("SSpersist: benchmarking string storage")
	var/amt = 1000
	var/list/pointer = list(amt)
	var/list/keys = list()
	var/list/values = list()
	for(var/i in 1 to 1000)
		keys += "[rand(1, 10000000)]"
		values += "[rand(1, 100000000000000)]"
	var/start = REALTIMEOFDAY
	string_save_benchmark(pointer, keys, values, amt)
	UNTIL(pointer[1] == 0)
	var/end = REALTIMEOFDAY
	message_admins("SSpersist: saving 1000 strings took [end - start] ds")
	pointer = list(amt)
	start = REALTIMEOFDAY
	string_load_benchmark(pointer, keys, amt)
	UNTIL(pointer[1] == 0)
	end = REALTIMEOFDAY
	message_admins("SSpersist: loading 1000 strings took [end - start] ds")
	usr = oldusr

/datum/controller/subsystem/persistence/proc/string_save_benchmark(list/pointer, list/keys, list/values, amt)
	set waitfor = FALSE
	for(var/i in 1 to amt)
		_string_save_benchmark(pointer, keys[i], values[i])

/datum/controller/subsystem/persistence/proc/string_load_benchmark(list/pointer, list/keys, amt)
	set waitfor = FALSE
	for(var/i in 1 to amt)
		_string_load_benchmark(pointer, keys[i])

/datum/controller/subsystem/persistence/proc/_string_save_benchmark(list/pointer, key, value)
	SaveString("benchmark", key, value)
	pointer[1]--

/datum/controller/subsystem/persistence/proc/_string_load_benchmark(list/pointer, key)
	LoadString("benchmark", key)
	pointer[1]--
