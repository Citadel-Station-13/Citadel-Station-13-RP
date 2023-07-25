//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

#warn see
#warn hear
#warn mob_see
#warn mob_hear

/mob/see(raw_message, message, name, voice_ident, atom/actor, remote)
	..()
	. = TRUE

/mob/hear(raw_message, message, name, voice_ident, atom/movable/actor, remote, datum/language/lang, list/spans, list/params)
	..()
	. = TRUE

/mob/narrate(raw_message)
	..()
	. = TRUE
	// todo: redirection support
	if(client)
		to_chat(client, raw_message)
