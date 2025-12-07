//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/vehicle_maint_controller/mecha
	vehicle_expected_type = /obj/vehicle/sealed/mecha
	vehicle_ui_path = "vehicle/mecha/MechaController"

#warn how to do component slots?

/datum/vehicle_maint_controller/mecha/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/vehicle_maint_controller/mecha/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/vehicle_maint_controller/mecha/update_component_refs()
	..()

/datum/vehicle_maint_controller/mecha/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/obj/vehicle/sealed/mecha/casted_vehicle = vehicle
	switch(action)
		if("changeIdLock")
			var/list/ids_to_add = params["add"]
			var/list/ids_to_remove = params["remove"]
		if("ejectPilot")
		if("removeCell")
		if("insertCell")

/datum/vehicle_maint_controller/mecha/ui_nested_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/vehicle_maint_controller/mecha/proc/encode_ui_faults()

/datum/vehicle_maint_controller/mecha/proc/queue_update_ui_faults()
	// TODO: queue
	update_ui_faults()

/datum/vehicle_maint_controller/mecha/proc/update_ui_faults()


#warn impl
