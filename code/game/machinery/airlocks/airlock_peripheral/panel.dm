//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: buildable

CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/airlock_peripheral/panel, 24)
/obj/machinery/airlock_peripheral/panel
	name = "airlock panel"
	desc = "A control panel for an airlock, linked to its main controller."
	icon = 'icons/machinery/airlocks/airlock_panel.dmi'
	icon_state = "panel"
	base_icon_state = "panel"

// TODO: on_power_change
/obj/machinery/airlock_peripheral/panel/power_change()
	. = ..()
	if(!.)
		return
	update_icon()

/obj/machinery/airlock_peripheral/panel/update_icon(updates)
	. = ..()
	if(machine_stat & NOPOWER)
		icon_state = "[base_icon_state]-off"
	else
		icon_state = "[base_icon_state]"
	// todo: handle 'operating' as "[base_icon_state]-active"

/obj/machinery/airlock_peripheral/panel/on_controller_leave(obj/machinery/airlock_component/controller/controller)
	..()
	SStgui.close_uis(src)

/obj/machinery/airlock_peripheral/panel/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	// TODO: clickchain support?
	if(!controller?.system)
		to_chat(user, SPAN_WARNING("[src] has no initialized controller."))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "machines/airlock/AirlockSystem")
		ui.open()

/obj/machinery/airlock_peripheral/panel/ui_data(mob/user, datum/tgui/ui)
	return controller?.system ? controller.system.ui_data(arglist(args)) : list()

/obj/machinery/airlock_peripheral/panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	SHOULD_CALL_PARENT(FALSE)
	return controller?.system ? controller.system.ui_act(arglist(args)) : TRUE

/obj/machinery/airlock_peripheral/panel/ui_status(mob/user, datum/ui_state/state)
	if(!controller?.system)
		return UI_CLOSE
	return ..()

CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/airlock_peripheral/panel/hardmapped, 24)
/obj/machinery/airlock_peripheral/panel/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	hardmapped = TRUE
