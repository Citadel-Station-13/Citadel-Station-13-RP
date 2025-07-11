//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station Developers           *//

/mob/verb/examine_entity_verb(atom/A as mob|obj|turf in view())
	set name = "Examine"
	set category = VERB_CATEGORY_IC

	examine_entity(A)
