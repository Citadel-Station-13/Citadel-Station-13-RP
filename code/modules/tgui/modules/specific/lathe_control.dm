/**
 * So why do we have discrete modules for lathe control?
 *
 * Because unfortunately, some lathes need to be able to be controlled from say,
 * a R&D console.
 *
 * This is not great because we'll potentially have to duplicate code.
 * So, we use a module to abstract it.
 *
 * This module somewhat 'abuses' the TGUI module / data reducer,
 * by keying designs in such a way that streaming new designs doesn't reqiure a full refresh.
 */
/datum/tgui_module/lathe_control
	tgui_id = "TGUILatheControl"
	expected_type = /obj/machinery/lathe

/datum/tgui_module/lathe_control/data(mob/user, ...)
	. = ..()

/datum/tgui_module/lathe_control/static_data(mob/user, ...)
	. = ..()

/datum/tgui_module/lathe_control/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/datum/tgui_module/lathe_control/proc/ui_design_data(list/datum/design/designs)

/datum/tgui_module/lathe_control/proc/ui_design_add(list/datum/design/designs)

/datum/tgui_module/lathe_control/proc/ui_design_remove(list/datum/design/designs)


#warn impl
