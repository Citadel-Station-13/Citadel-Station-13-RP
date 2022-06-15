/datum/controller/subsystem/persistence
	/// loaded pictures by md5
	var/static/list/datum/picture/pictures_by_hash


/**
 * fetches a picture of a hash
 */
/datum/controller/subsystem/persistence/proc/fetch_picture(hash)
	RETURN_TYPE(/datum/picture)

/**
 * checks if a hash of a picture exists
 */
/datum/controller/subsystem/persistence/proc/picture_exists(hash)

/**
 * registers a new picture
 */
/datum/controller/subsystem/persistence/proc/save_picture(datum/picture/P)

#warn impl all
