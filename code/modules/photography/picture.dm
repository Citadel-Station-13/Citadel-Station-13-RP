/**
 * loads / holds image hashes / whatnot
 *
 * cares not for text metadata like names/anything mutable.
 */
/datum/picture
	/// image hash (used for unique identification)
	var/image_hash
	/// image - loaded into memory
	var/icon/image_loaded
	/// image - are we loaded?
	var/image_loaded = TRUE
	/// image - are we flushed to disk + sql?
	var/image_saved = FALSE
	/// width in pixels
	var/width
	/// height in pixels
	var/height
	/// cached 8x8 thumbnail
	var/icon/eight_by_eight
	/// cached 4x4 thumbnail
	var/icon/four_by_four

#warn impl all

/datum/picture/proc/load()
	if(image_loaded)
		return TRUE

/datum/picture/proc/unload()


/datum/picture/proc/fetch_8x8()
	ASSERT(load())

/datum/picture/proc/fetch_4x4()
	ASSERT(load())
