//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * you ever just like. open your mind?
 * that's fun, isn't it?
 */
// todo: DECLARE_MOB_VERB
/mob/verb/open_mind()
	set name = "Memory"
	set desc = "Look inwards and access your mind." // rp server btw
	set category = VERB_CATEGORY_IC

	// todo: maybe don't log this here?
	log_game("[key_name(usr)] invoked open_mind on [key_name(src)]")

	if(!mind)
		to_chat(usr, SPAN_NOTICE("You do not have a mind."))
		return

	mind.ui_interact(src)
