/**
 * ! Unique Mapped Objects
 *
 * used for any kind of object loaded by UID and a mapping sting
 * does not store coordinates, unlike unique-generic objects
 *
 * use this for mapped in objects and loadout objects.
 * map is not required, for shared map systems.
 */
/datum/controller/subsystem/persistence
	/// objects we need to track
	var/static/list/unique_mapped_objects = list()

/datum/controller/subsystem/persistence/proc/FetchStaticObjectData(uid, map)
	RETURN_TYPE(/list)

/datum/controller/subsystem/persistence/proc/FetchStaticDatumData(uid, map)

/datum/controller/subsystem/persistence/proc/StoreStaticObjectData(uid, data, map)

/datum/controller/subsystem/persistence/proc/StoreStaticDatumData(uid, data, map)

/datum/controller/subsystem/persistence/proc/WipeStatiObjectData(uid, map)

/datum/controller/subsystem/persistence/proc/GetStaticObjectIDs(map)
	RETURN_TYPE(/list)

/datum/controller/subsystem/persistence/proc/HasStaticObjectData(uid, map)

#warn impl
