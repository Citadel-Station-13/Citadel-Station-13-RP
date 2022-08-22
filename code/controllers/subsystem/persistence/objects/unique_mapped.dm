/**
 * ! Unique Mapped Objects
 *
 * used for any kind of object loaded by UID and a mapping sting
 * does not store coordinates, unlike unique-generic objects
 *
 * use this for mapped in objects and loadout objects
 */
/datum/controller/subsystem/persistence
	/// objects we need to track
	var/static/list/unique_mapped_objects = list()

/datum/controller/subsystem/persistence/proc/FetchObjectData(uid, map)

/datum/controller/subsystem/persistence/proc/StoreObjectData(uid, data, map)
