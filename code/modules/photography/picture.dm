/**
 * loads / holds image hashes / whatnot
 *
 * cares not for text metadata like names/anything mutable.
 */
/datum/picture
	/// image hash (used for unique identification)
	var/image_hash
	/// image - are we loaded?
	var/image_loaded = TRUE
	/// image - are we flushed to disk + sql?
	var/image_saved = FALSE
	/// width in pixels
	var/width
	/// height in pixels
	var/height
	/// image - loaded into memory
	var/icon/full
	/// cached 8x8 thumbnail
	var/icon/eight_by_eight
	/// cached 4x4 thumbnail
	var/icon/four_by_four
	/// cached paperwork overlay
	var/icon/paperwork_overlay

/datum/picture/proc/load()
	if(image_loaded)
		return TRUE
	var/path = SSphotography.path_for_picture(image_hash)
	if(isnull(path))
		return FALSE
	full = icon(path)
	image_loaded = TRUE
	return TRUE

/datum/picture/proc/unload()
	if(!image_saved)
		// can't, we'd lose data
		return FALSE
	if(!image_loaded)
		return TRUE
	full = null
	eight_by_eight = null
	four_by_four = null
	image_loaded = FALSE
	return TRUE

/**
 * sends as icon
 */
/datum/picture/proc/rsc_src(list/client/clients)
	if(!islist(clients))
		clients = list(clients)
	if(!load())
		return
	var/rng_path = "picture_[rand(1, 10000)].png"
	for(var/client/C as anything in clients)
		C << browse_rsc(full, rng_path)
	return rng_path

/**
 * gets img src
 */
/datum/picture/proc/img_src(list/client/clients)
	return SSphotography.url_for_picture(image_hash, clients)

/datum/picture/proc/icon_full()
	ASSERT(load())
	return full

/datum/picture/proc/icon_8x8()
	if(!isnull(eight_by_eight))
		return eight_by_eight
	if(!load())
		return
	var/icon/scaling = icon(full)
	scaling.Scale(8, 8)
	eight_by_eight = scaling
	return eight_by_eight

/datum/picture/proc/icon_4x4()
	if(!isnull(four_by_four))
		return four_by_four
	if(!load())
		return
	var/icon/scaling = icon(full)
	scaling.Scale(4, 4)
	four_by_four = scaling
	return four_by_four

/datum/picture/proc/paperwork_overlay()
	if(!isnull(paperwork_overlay))
		return paperwork_overlay
	if(!load())
		return
	var/icon/generating = icon('icons/modules/photography/photo_overlay_6x7.dmi', "photo")
	generating.Blend(icon_4x4(), BLEND_OVERLAY, 2, 3)
	paperwork_overlay = generating
	return paperwork_overlay
