/**
 *! Copyright (c) 2021 Arm A. Hammer
 *! SPDX-License-Identifier: MIT
 */

/**
 * tgui state: never_state
 *
 * Always closes the UI, no matter what. See the ui_state in religious_tool.dm to see an example
 */

GLOBAL_DATUM_INIT(never_state, /datum/ui_state/never_state, new)

/datum/ui_state/never_state/can_use_topic(datum/src_object, mob/user, datum/tgui/ui)
	return UI_CLOSE
