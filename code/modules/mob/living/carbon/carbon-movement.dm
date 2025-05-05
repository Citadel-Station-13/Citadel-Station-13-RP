//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Sets our base movespeed from a config lookup.
 */
/mob/living/carbon/get_movespeed_base()
	#warn impl

/mob/living/carbon/get_movespeed_config_tags()
	. = ..()
	. += "human"
	. += "human-species-id-[species.uid]"
	. += "human-species-id-[species.id]"
