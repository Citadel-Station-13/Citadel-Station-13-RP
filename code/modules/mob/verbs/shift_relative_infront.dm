//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//
// todo: DECLARE_MOB_VERB
/mob/verb/shift_relative_infront()
	set name = "Move Infront"
	set desc = "Move infront of a mob with the same base layer as yourself"
	set src = usr
	set category = VERB_CATEGORY_IC

	if(!client.throttle_verb())
		return

	var/mob/M = tgui_input_list(src, "What mob to move infront?", "Move Infront", get_relative_shift_targets())

	if(QDELETED(M))
		return

	set_relative_layer(M.relative_layer + 1)
