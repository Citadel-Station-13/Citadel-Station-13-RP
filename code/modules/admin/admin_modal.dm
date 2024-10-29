//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GLOBAL_DATUM_INIT(ui_admin_modal_state, /datum/ui_state/admin_modal_state, new)

/datum/ui_state/admin_modal_state/can_use_topic(src_object, mob/user)
	. = ..()


/**
 * Base type of admin modals, which tend to be standalone panels.
 */
/datum/admin_modal
	/// TGUI ID
	var/tgui_interface
	/// Do we autoupdate?
	var/tgui_update = TRUE
#warn impl

/datum/admin_modal/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/datum/admin_modal/ui_state()
	. = ..()


