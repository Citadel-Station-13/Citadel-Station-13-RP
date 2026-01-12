//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Holds the UI & handling, despite the controller physically holding state.
 * * Borrowed by panels to allow UI access
 */
/datum/airlock_system

/datum/airlock_system/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/datum/airlock_system/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()

/datum/airlock_system/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/airlock_system/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()






#warn impl
