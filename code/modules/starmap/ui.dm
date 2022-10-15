/datum/starmap/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/datum/starmap/ui_static_data(mob/user)
	. = ..()

/datum/starmap/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/datum/starmap/proc/data(mob/user, datum/tgui/ui, datum/ui_state/state)
	return ui_data(user, ui, state)

/datum/starmap/proc/static_data(mob/user)
	return ui_static_data(user)

/datum/starmap/proc/act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	return ui_act(action, params, ui, state)
