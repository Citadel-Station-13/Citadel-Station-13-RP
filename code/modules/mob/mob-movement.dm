//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Updates our base move delay
 */
/mob/proc/update_movespeed_base()

/**
 * @return base movement speed in tiles per second
 */
/mob/proc/get_movespeed_base()
	return 20

/**
 * Gets list of string tags we count as in movespeed configuration overrides.
 *
 * @return ordered list with later elements overriding earlier ones
 */
/mob/proc/get_movespeed_config_tags()
	. = list("type-[replacetext("[type]", "/", "-")]")

#warn impl all

