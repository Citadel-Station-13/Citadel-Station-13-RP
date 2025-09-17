//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * zoom system for items to let you zoom around in a radius around you
 *
 * mouse-reactive, unlike just boosting vision range
 */
/datum/component/freezoom
	var/is_active = FALSE

#warn impl

/datum/component/freezoom/proc/update_zoom(mob/viewer, list/mouse_params)


/datum/component/freezoom/proc/set_active(new_active)
