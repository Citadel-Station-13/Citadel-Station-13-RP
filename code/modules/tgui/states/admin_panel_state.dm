//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* UI State *//

GLOBAL_DATUM_INIT(ui_admin_panel_state, /datum/ui_state/admin_panel_state, new)

/**
 * Admin panel state. **Only valid on /datum/admin_panel.**
 */
VV_PROTECT_READONLY(/datum/admin_panel_state)
/datum/ui_state/admin_panel_state

/datum/ui_state/admin_panel_state/can_use_topic(datum/admin_panel/src_object, mob/user)
	return src_object.owner.owner == user.client ? UI_INTERACTIVE : UI_CLOSE
