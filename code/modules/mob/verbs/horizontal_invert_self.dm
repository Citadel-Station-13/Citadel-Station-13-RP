//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/verb/horizontal_invert_self()
	set name = "Invert Yourself (Horizontal)"
	set desc = "Mirror your sprite across the N-S axis."
	set category = VERB_CATEGORY_IC

	// logging here

	var/matrix/our_transform = transform
	our_transform.Scale(-1, 1)
	transform = our_transform

