//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Sets our base movespeed from a config lookup.
 */
/mob/living/silicon/pai/get_movespeed_base()
	return movement_base_speed

/mob/living/silicon/pai/get_movespeed_config_tags()
	. = ..()
	. += "pai"
