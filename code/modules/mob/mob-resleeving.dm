//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* helpers / API for the resleeving module *//

/**
 * Checks for API support for mirrors
 * * Any mob that returns TRUE for this should implement all `resleeving_x_mirror` procs.
 */
/mob/proc/resleeving_supports_mirrors()
	return FALSE

/**
 * Ensures the target has a mirror.
 */
/mob/proc/resleeving_create_mirror() as /obj/item/implant/mirror
	return null

/**
 * Gets the target's mirror, if any
 */
/mob/proc/resleeving_get_mirror() as /obj/item/implant/mirror
	return null

/**
 * transfers the target's mirror out, if any, returning it
 */
/mob/proc/resleeving_remove_mirror(atom/new_loc) as /obj/item/implant/mirror
	return null
