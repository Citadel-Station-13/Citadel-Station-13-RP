/**
 * picture system
 *
 * uses SQL to save metadata
 *
 * if picture saving is not enabled, pictures still work; they just won't be saved and will use old asset
 * sending format.
 */
/datum/controller/subsystem/persistence
	/// loaded pictures by md5
	var/static/list/datum/picture/pictures_by_hash

/**
 * constructs a new, freshly taken picture.
 *
 * doesn't fill metadata, you can do that.
 */
/datum/controller/subsystem/persistence/proc/construct_picture(icon/I)
	RETURN_TYPE(/datum/picture)

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
 * saves a picture's metadata to disk. construct_picture will save the .png
 */
/datum/controller/subsystem/persistence/proc/save_picture(datum/picture/P)

#warn impl all
