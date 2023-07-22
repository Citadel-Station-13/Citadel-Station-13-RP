//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * recognition system
 *
 * basically,
 * * mobs that participate in this get a face and voice identifier
 * * mobs that want to use this have a recognition holder to hold lookup data
 *
 * yeah we'll see how this goes
 */


/mob/proc/create_recognition(list/restore_data)
	ASSERT(isnull(recognition))
	recognition = new /datum/recognition_holder(src, restore_data)

/mob/proc/create_identity(list/restore_data)
	ASSERT(isnull(identity))
	identity = new /datum/identity_holder(src, restore_data)

/mob/proc/change_facial_identity(identifier)
	return isnull(identity)? FALSE : identity.change_facial_identifier(identifier)

/mob/proc/change_vocal_identity(identifier)
	return isnull(identity)? FALSE : identity.change_voice_identifier(identifier)

/mob/proc/seed_facial_identity(identifier)
	return isnull(identity)? FALSE : identity.seed_facial_identity(identifier)

/mob/proc/seed_vocal_identity(identifier)
	return isnull(identity)? FALSE : identity.seed_voice_identity(identifier)

/mob/proc/randomize_facial_identity(identifier)
	return isnull(identity)? FALSE : identity.change_facial_identifier(identity.random_facial_identifier)

/mob/proc/randomize_vocal_identity(identifier)
	return isnull(identity)? FALSE : identity.change_voice_identifier(identity.random_voice_identifier)

#warn impl all
