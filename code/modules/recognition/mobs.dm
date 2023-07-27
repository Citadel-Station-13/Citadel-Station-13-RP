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

//* recognition API

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
	return isnull(identity)? FALSE : identity.change_facial_identifier(identity.random_facial_identifier())

/mob/proc/randomize_vocal_identity(identifier)
	return isnull(identity)? FALSE : identity.change_voice_identifier(identity.random_voice_identifier())

/**
 * returns what someone's name should be when we hear them
 */
/mob/proc/recognize_vocal_identifier(identifier)
	#warn impl

/**
 * returns what someone's face should be when we ese them
 */
/mob/proc/recognize_facial_identifier(identifier)
	#warn impl

//* external / wrapper / helper API

/**
 * run face recognition on another mob
 *
 * this assumes we can see their face clearly, and it is not obscured/disfigured
 * the recognition system does *not* handle disfigurement.
 *
 * @return rendered name, real face name if M does not exist or either us or them do not use recognition system.
 */
/mob/proc/recognize_face(mob/M)
	#warn impl

/**
 * run vocal recognition on another mobmob
 *
 * this assumes we can hear their voice clearly and it's not being modified.
 * the recognition system does not handle voice modification.
 *
 * @return rendered name, real voice name if M does not exist or either us or them do not use recognition system.
 */
/mob/proc/recognize_voice(mob/M)
	#warn impl
