/**
 * loads / holds full images with mutable metadata like things people caption it with.
 *
 * this is the 'second tier' ontop of pictures for de-duping data
 *
 * third tier is the photo / implementing object itself.
 */
/datum/photograph
	/// are we saved? we won't have an ID without being saved
	var/saved = FALSE
	/// our unique id - set by subsystem
	var/id
	/// picture hash
	var/picture_hash
	/// "you see a photo of [scene]". do not let players set this.
	var/scene
	/// description: "you see a photo of [scene]. [description]". do not let players set this.
	var/desc
	/// caption. can be set by players.
	var/caption

#warn impl all

/datum/photograph/proc/mutable_clone()

/datum/photograph/proc/picture()
	return SSphotography.resolve_picture(picture_hash)

/datum/photograph/proc/unload()
