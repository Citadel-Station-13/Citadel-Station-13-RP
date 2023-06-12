/**
 * loads / holds full images with mutable metadata like things people caption it with.
 *
 * this is the 'second tier' ontop of pictures for de-duping data
 *
 * third tier is the photo / implementing object itself.
 *
 * saving/loading handled in SSphotography; blindly adding variables will NOT save them.
 */
/datum/photograph
	/// are we saved? we won't have an ID without being saved. this also determines if we're mutable.
	var/saved = FALSE
	/// our unique id - set by subsystem on save
	var/id
	/// picture hash
	var/picture_hash
	/// "you see a photo of [scene]". do not let players set this.
	var/scene
	/// description: "you see a photo of [scene]. [description]". do not let players set this.
	var/desc

/datum/photograph/proc/from_image(icon/I)
	ASSERT(!saved)
	var/datum/picture/pic = SSphotography.create_picture(I)
	picture_hash = pic.image_hash

/datum/photograph/proc/mutable_clone()
	var/datum/photograph/clone = new
	clone.picture_hash = picture_hash
	clone.scene = scene
	clone.desc = desc
	return clone

/datum/photograph/proc/picture()
	return SSphotography.resolve_picture(picture_hash)

/datum/photograph/proc/img_src(list/client/clients)
	return SSphotography.url_for_picture(picture_hash, clients)

/datum/photograph/proc/load()
	// not much to load
	return TRUE

/datum/photograph/proc/unload()
	// not much to unload
	return TRUE
