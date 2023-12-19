/**
 * POV: stretching the new modules system to its limits
 *
 * Teleporter control modules, used in both
 * telescience remotes as well as teleporter control consoles
 *
 * These are actually owned by the teleporter_controller, and just referenced on receiving objects.
 *
 * Some technical implementation details:
 * * modules should be added to the module list of the implementing interface
 * * data should be added to the module list as the id as per usual
 *
 * This is because we don't have multi-layer module support, so we're doing something weird here.
 */
/datum/tgui_module/teleporter_control

#warn impl all

/datum/tgui_module/teleporter_control/data(mob/user)
	var/obj/machinery/teleporter_controller/controller = host
	. = ..()
	#warn impl

/datum/tgui_module/teleporter_control/static_data(mob/user)
	var/obj/machinery/teleporter_controller/controller = host
	. = ..()
	#warn impl

/datum/tgui_module/teleporter_control/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	var/obj/machinery/teleporter_controller/controller = host
	#warn impl

/datum/tgui_module/teleporter_control/ui_module_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/obj/machinery/teleporter_controller/controller = host
	. = ..()
	#warn impl

/datum/tgui_module/teleporter_control/ui_module_static(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/obj/machinery/teleporter_controller/controller = host
	. = ..()
	#warn impl

/datum/tgui_module/teleporter_control/ui_module_route(action, list/params, datum/tgui/ui, id)
	. = ..()
	#warn impl
