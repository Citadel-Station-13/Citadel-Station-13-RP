/**
 *! Copyright (c) 2020 Aleksej Komarov
 *! SPDX-License-Identifier: MIT
 */

/**
 * tgui state: observer_state
 *
 * Checks that the user is an observer/ghost.
 */

GLOBAL_DATUM_INIT(observer_state, /datum/ui_state/observer_state, new)

/datum/ui_state/observer_state/can_use_topic(datum/src_object, mob/user, datum/tgui/ui)
	if(isobserver(user))
		return UI_INTERACTIVE
	return UI_CLOSE
