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

/datum/recognition_holder/proc/detach()
	GLOB.active_recognition_holders -= src

/**
 * @return old name if there was one
 */
/datum/recognition_holder/proc/set_face_identity(identifier, name)
	. = voice_lookup[identifier]
	// we always remove first so oldest non-updated entries are first.
	face_lookup -= identifier
	// blank name counts as null
	if(!name)
		return
	face_lookup[identifier] = name
	if(length(face_lookup) > MOB_RECOGNITION_MAX_ENTRIES)
		face_lookup.Cut(1, length(face_lookup) - MOB_RECOGNITION_MAX_ENTRIES + 1)

/**
 * @return old name if there was one
 */
/datum/recognition_holder/proc/set_voice_identity(identifier, name)
	. = voice_lookup[identifier]
	// we always remove first so oldest non-updated entries are first.
	voice_lookup -= identifier
	// blank name counts as null
	if(!name)
		return
	voice_lookup[identifier] = name
	if(length(voice_lookup) > MOB_RECOGNITION_MAX_ENTRIES)
		voice_lookup.Cut(1, length(voice_lookup) - MOB_RECOGNITION_MAX_ENTRIES + 1)

/datum/recognition_holder/proc/face_lookup(identifier)
	return face_lookup[identifier]

/datum/recognition_holder/proc/voice_lookup(identifier)
	return voice_lookup[identifier]

/datum/recognition_holder/deserialize(list/data)
	. = ..()
	face_lookup = data["face"]
	if(!islist(face_lookup))
		face_lookup = list()
	if(length(face_lookup) > MOB_RECOGNITION_MAX_ENTRIES)
		face_lookup.len = MOB_RECOGNITION_MAX_ENTRIES
	voice_lookup = data["voice"]
	if(!islist(voice_lookup))
		voice_lookup = list()
	if(length(voice_lookup) > MOB_RECOGNITION_MAX_ENTRIES)
		voice_lookup.len = MOB_RECOGNITION_MAX_ENTRIES

/datum/recognition_holder/serialize()
	. = ..()
	if(!islist(face_lookup))
		face_lookup = list()
	if(length(face_lookup) > MOB_RECOGNITION_MAX_ENTRIES)
		face_lookup.len = MOB_RECOGNITION_MAX_ENTRIES
	.["face"] = face_lookup
	if(!islist(voice_lookup))
		voice_lookup = list()
	if(length(voice_lookup) > MOB_RECOGNITION_MAX_ENTRIES)
		voice_lookup.len = MOB_RECOGNITION_MAX_ENTRIES
	.["voice"] = voice_lookup
