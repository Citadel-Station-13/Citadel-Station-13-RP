//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/mob/see(raw_message, message, name, face_ident, atom/actor, remote)
	..()
	return mob_see(arglist(args))

/mob/hear(raw_message, message, name, voice_ident, atom/movable/actor, remote, datum/language/lang, list/spans, list/params)
	..()
	return mob_hear(arglist(args))

/mob/narrate(raw_message)
	..()
	. = TRUE
	// todo: redirection support
	if(client)
		to_chat(client, raw_message)

/mob/proc/mob_see(raw_message, message, name, face_ident, atom/actor, remote)
	if(is_blind())
		return FALSE

	#warn mob_see

/mob/proc/mob_hear(raw_message, message, name, voice_ident, atom/movable/actor, remote, datum/language/lang, list/spans, list/params)
	#warn mob_hear

