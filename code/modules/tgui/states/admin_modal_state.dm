//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* UI State *//

GLOBAL_DATUM_INIT(ui_admin_modal_state, /datum/ui_state/admin_modal_state, new)

/**
 * Admin modal state. **Only valid on /datum/admin_modal.**
 */
VV_PROTECT_READONLY(/datum/admin_modal_state)
/datum/ui_state/admin_modal_state

/datum/ui_state/admin_modal_state/can_use_topic(datum/admin_modal/src_object, mob/user)
	return src_object.owner.owner == user.client ? UI_INTERACTIVE : UI_CLOSE
