//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// todo: DECLARE_MOB_VERB
/mob/verb/set_self_relative_layer()
	set name = "Set relative layer"
	set desc = "Set your relative layer to other mobs on the same layer as yourself"
	set src = usr
	set category = VERB_CATEGORY_IC

	var/new_layer = input(src, "What do you want to shift your layer to? (-100 to 100)", "Set Relative Layer", clamp(relative_layer, -100, 100))
	new_layer = clamp(new_layer, -100, 100)
	set_relative_layer(new_layer)
