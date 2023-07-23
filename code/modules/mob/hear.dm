//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

#warn see
#warn hear
#warn mob_see
#warn mob_hear

/mob/narrate(raw_message)
	..()
	// todo: redirection support
	if(client)
		to_chat(client, raw_message)
