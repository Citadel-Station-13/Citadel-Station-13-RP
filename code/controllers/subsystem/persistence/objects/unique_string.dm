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

//! Why the usr fuckery? Because we intentionally wish to obfuscate admin proccalls, since we properly sanitize **everything** in these procs.

/datum/controller/subsystem/persistence/proc/LoadString(group, key)
	if(!SSdbcore.Connect())
		return
	var/old = usr
	usr = null
	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT value FROM [format_table_name("persist_keyed_strings")] WHERE group = :group, key = :key",
		list(
			"group" = group,
			"key" = key
		)
	)
	query.Execute()
	usr = old
	if(!query.NextRow())
		return
	return query.item[1]

/datum/controller/subsystem/persistence/proc/SaveString(group, key, value)
	if(!SSdbcore.Connect())
		return
	var/old = usr
	usr = null
	var/datum/db_query/query = SSdbcore.NewQuery(
		"INSERT INTO [format_table_name("persist_keyed_strings")] (group, key, value) VALUES (:group, :key, :value) ON DUPLICATE KEY UPDATE value = VALUES(value), modified = Now()",
		list(
			"group" = group,
			"key" = key,
			"value" = value
		)
	)
	query.Execute()
	usr = old
	qdel(query)

/datum/controller/subsystem/persistence/proc/benchmark_strings()
	var/oldusr = usr
	usr = null
	message_admins("SSpersist: benchmarking string storage")
	var/start = REALTIMEOFDAY
	for(var/i in 1 to 10000)
		SaveString("benchmark", "foo", "bar")
	var/end = REALTIMEOFDAY
	message_admins("SSpersist: saving 10000 strings took [end - start] ds")
	var/start = REALTIMEOFDAY
	for(var/i in 1 to 10000)
		LoadString("benchmark", "foo")
	var/end = REALTIMEOFDAY
	message_admins("SSpersist: loading 10000 strings took [end - start] ds")
