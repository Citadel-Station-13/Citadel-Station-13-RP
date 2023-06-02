GLOBAL_LIST_EMPTY(active_recognition_holders)

/**
 * holds and synchronizes recognition associations
 */
/datum/recognition_holder
	/// who we belong to
	var/mob/host
	/// face identifiers to names
	var/list/face_lookup = list()
	/// voice identifiers to names
	var/list/voice_lookup = list()

/datum/recognition_holder/New(mob/host, list/data)
	src.host = host
	if(!isnull(data))
		deserialize(data)
	attach()

/datum/recognition_holder/Destroy()
	detach()
	src.host = null
	return ..()

/datum/recognition_holder/proc/attach()
	GLOB.active_recognition_holders += src
	host.ensure_self_perspective()
	// add all holders
	for(var/datum/identity_holder/holder as anything in GLOB.active_identity_holders)
		register_identity(holder)

/datum/recognition_holder/proc/detach()
	GLOB.active_recognition_holders -= src
	// clear out holders
	for(var/datum/identity_holder/holder as anything in GLOB.active_identity_holders)
		unregister_identity(holder)

/datum/recognition_holder/proc/register_identity(datum/identity_holder/holder)

/datum/recognition_holder/proc/unregister_identity(datum/identity_holder/holder)

/**
 * @return old name if there was one
 */
/datum/recognition_holder/proc/set_face_identity(identifier, name)

/**
 * @return old name if there was one
 */
/datum/recognition_holder/proc/set_voice_identity(identifier, name)
	. = voice_lookup[identifier]
	// blank name counts as null
	if(!name)
		voice_lookup -= identifier
	else
		voice_lookup[identifier] = name

#warn impl all
