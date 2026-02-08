//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/vehicle_ui_controller/mecha
	vehicle_expected_type = /obj/vehicle/sealed/mecha
	vehicle_ui_path = "vehicle/mecha/fighter/MechaController"

/datum/vehicle_ui_controller/mecha/fighter/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	var/obj/vehicle/sealed/mecha/fighter/casted_vehicle = vehicle
	.["flightMode"] = casted_vehicle.flight_mode

/datum/vehicle_ui_controller/mecha/fighter/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/obj/vehicle/sealed/mecha/fighter/casted_vehicle = vehicle
	switch(action)
		if("toggleFlight")
			var/wanted = params["active"]
			if(wanted && !casted_vehicle.flight_mode)
				casted_vehicle.user_enable_flight(actor)
			else if(!wanted && casted_vehicle.flight_mode)
				casted_vehicle.user_disable_flight(actor)
			return TRUE

/datum/vehicle_ui_controller/mecha/fighter/proc/update_ui_flight()
	var/obj/vehicle/sealed/mecha/fighter/casted_vehicle = vehicle
	push_ui_data(list("flightMode" = casted_vehicle.flight_mode))
