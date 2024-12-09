//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/verb/horizontal_invert_self()
	set name = "Invert Yourself (Horizontal)"
	set desc = "Mirror your sprite across the N-S axis."
	set category = VERB_CATEGORY_IC

	// todo: remote control? mobs that don't allow it?

	log_game("[key_name(usr)] invoked horizontal_invert_self on [key_name(src)].")

	var/datum/component/mob_self_horizontal_inversion/inversion = GetComponent(/datum/component/mob_self_horizontal_inversion)
	if(inversion)
		qdel(inversion)
	else
		AddComponent(/datum/component/mob_self_horizontal_inversion)
