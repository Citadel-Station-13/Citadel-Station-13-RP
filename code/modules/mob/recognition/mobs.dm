/**
 * recognition system
 *
 * basically,
 * * mobs get a face and voice identifier that participate in this
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

/mob/proc/change_vocal_identity(identifier)

/mob/proc/randomize_facial_identity(identifier)

/mob/proc/randomize_vocal_identity(identifier)

#warn impl all
