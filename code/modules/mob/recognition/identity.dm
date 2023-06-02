GLOBAL_LIST_EMPTY(active_identity_holders)

/**
 * holds and synchronizes identity data
 */
/datum/identity_holder
	/// who we belong to
	var/mob/host
	/// face / visual identifier
	var/facial_identifier
	/// say / vocal identifier
	var/voice_identifier
	/// cached image for unknown identity
	var/image/unknown_image
	/// cached image for named images
	var/list/named_images = list()

/datum/identity_holder/New(mob/host, list/data)
	src.host = host
	if(!isnull(data))
		deserialize(data)
	if(isnull(facial_identifier))
		facial_identifier = random_facial_identifier()
	if(isnull(voice_identifier))
		voice_identifier = random_voice_identifier()
	attach()

/datum/identity_holder/Destroy()
	detach()
	src.host = null
	return ..()

/datum/identity_holder/proc/attach()
	GLOB.active_identity_holders += src
	// add to active recognition datums
	for(var/datum/recognition_holder/holder as anything in GLOB.active_recognition_holders)
		holder.register_identity(src)

/datum/identity_holder/proc/detach()
	GLOB.active_identity_holders -= src
	// remove from active recognition datums
	for(var/datum/recognition_holder/holder as anything in GLOB.active_recognition_holders)
		holder.unregister_identity(src)

/datum/identity_holder/proc/get_unknown_image()

/datum/identity_holder/proc/get_named_image(name)

/datum/identity_holder/proc/change_facial_identifier(identifier)

/datum/identity_holder/proc/change_voice_identifier(identifier)

/datum/identity_holder/proc/random_facial_identifier()
	return random_identifier()

/datum/identity_holder/proc/random_voice_identifier()
	return random_identifier()

/datum/identity_holder/proc/random_identifier()
	return sha1(GUID())

#warn impl all
