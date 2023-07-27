//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

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

/datum/identity_holder/proc/detach()
	GLOB.active_identity_holders -= src

/datum/identity_holder/proc/change_facial_identifier(identifier)
	detach()
	facial_identifier = identifier
	attach()
	return TRUE

/datum/identity_holder/proc/change_voice_identifier(identifier)
	detach()
	voice_identifier = identifier
	attach()
	return TRUE

/datum/identity_holder/proc/seed_facial_identity(seed)
	return change_facial_identifier(seeded_identifier(seed))

/datum/identity_holder/proc/seed_voice_identity(seed)
	return change_voice_identifier(seeded_identifier(seed))

/datum/identity_holder/proc/random_facial_identifier()
	return random_identifier()

/datum/identity_holder/proc/random_voice_identifier()
	return random_identifier()

/datum/identity_holder/proc/random_identifier()
	return sha1(GUID())

/datum/identity_holder/proc/seeded_identifier(seed)
	return sha1(seed)

/datum/identity_holder/proc/facial_discriminator()
	return recognition_identifier_discriminator(facial_identifier)

/datum/identity_holder/proc/voice_discriminator()
	return recognition_identifier_discriminator(voice_identifier)

/proc/recognition_identifier_discriminator(identifier)
	var/identifier_length = length(identifier)
	if(identifier_length < 4)
		return identifier
	return copytext(identifier, length(identifier) - 4 + 1)

/datum/identity_holder/serialize()
	. = ..()
	.["face"] = facial_identifier
	.["voice"] = voice_identifier

/datum/identity_holder/deserialize(list/data)
	. = ..()
	facial_identifier = data["face"]
	voice_identifier = data["voice"]
