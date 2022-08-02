/**
 * ! Unique String Persistence
 *
 * this is the "generic store anything by key/value" system
 * map specific string load is allowed but not required.
 *
 * use if none of the others can work
 * or if you're somehow too lazy to optimize your persistence system by making a new persistence type
 * but somehow not lazy enough to optimize it into a string??
 */
/datum/controller/subsystem/persistence
	/// persistent string cache
	var/static/list/persistent_string_cache

/datum/controller/subsystem/persistence/InitPersistence()
	if(islist(persistent_string_cache))
		FlushStrings()
	persistent_string_cache = list()

/datum/controller/subsystem/persistence/proc/LoadStrings(map, ...)
	if(!SSdbcore.Connect())
		return

/datum/controller/subsystem/persistence/proc/GetString(key, map = PERSISTENCE_MAP_AGNOSTIC)
	var/list/specific = persistent_string_cache[map]
	if(!specific)
		persistent_string_cache[map] = specific = list()
	if(!specific[key])
		LoadStrings(map, ...)
	return specific[key]

/datum/controller/subsystem/persistence/proc/SetString(key, value, map = PERSISTENCE_MAP_AGNOSTIC, flush)
	var/list/specific = persistent_string_cache[ma]
	if(!specific)
		persistent_string_cache[map] = specific = list()
	specific[key] = value
	if(flush)
		FlushStrings(map, key = value)

/datum/controller/subsystem/persistence/proc/FlushStrings(map, ...)
	if(!SSdbcore.Connect())
		return


