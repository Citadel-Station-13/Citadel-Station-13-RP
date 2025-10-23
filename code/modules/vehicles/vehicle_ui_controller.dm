//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/vehicle_ui_controller
	var/obj/vehicle/vehicle

/datum/vehicle_ui_controller/New(obj/vehicle/vehicle)
	src.vehicle = vehicle

/datum/vehicle_ui_controller/Destroy()
	if(vehicle.ui_controller == src)
		vehicle.ui_controller = null
	return ..()

/datum/vehicle_ui_controller/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/vehicle_ui_controller/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/vehicle_ui_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()

/datum/vehicle_ui_controller/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VehicleController")
		ui.open()

/datum/vehicle_ui_controller/ui_nested_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/vehicle_ui_controller/ui_state(mob/user)
	. = ..()


#warn impl
