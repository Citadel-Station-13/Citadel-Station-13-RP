//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/admin_panel/game
	tgui_interface = "AdminPanelGame"

/datum/admin_panel/game/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/datum/admin_panel/game/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/datum/admin_panel/game/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/datum/admin_panel/game/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/datum/admin_panel/game/ui_status(mob/user, datum/ui_state/state, datum/tgui_module/module)
	. = ..()

/datum/admin_panel/game/ui_state(mob/user, datum/tgui_module/module)
	. = ..()

#warn impl all
#warn tgui interface
