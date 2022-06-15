/datum/controller/subsystem/persistence
	/// loaded pictures by md5
	var/static/list/datum/picture/pictures_by_hash

/datum/controller/subsystem/persistence/proc/fetch_picture(hash)
	RETURN_TYPE(/datum/picture)

/datum/controller/subsystem/persistence/proc/picture_exists(hash)

/datum/controller/subsystem/persistence/proc/save_picture(datum/picture/P)

#warn impl all
