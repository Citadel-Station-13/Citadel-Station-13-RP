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
	.["faults"] = encode_ui_faults()

/datum/vehicle_maint_controller/mecha/update_component_refs()
	..()

/datum/vehicle_maint_controller/mecha/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/obj/vehicle/sealed/mecha/casted_vehicle = vehicle

	if(!actor.performer.Reachability(casted_vehicle) || !casted_vehicle.maint_panel_is_accessible())
		return TRUE
	// below here requires panel access //
	switch(action)
		if("ejectPilot")
		if("removeCell")
		if("insertCell")
		if("fixShortCircuitFault")
		if("fixTankBreachFault")
		if("fixActuatorCalibrationFault")
		if("fixCabinBreachFault")
		if("fixTemperatureControllerFault")

	#warn impl all

/datum/vehicle_maint_controller/mecha/ui_nested_data(mob/user, datum/tgui/ui)
	. = ..()
	#warn impl

/datum/vehicle_maint_controller/mecha/proc/encode_ui_faults()
	var/list/encoding = list()
	var/obj/vehicle/sealed/mecha/casted_vehicle = vehicle
	for(var/path in casted_vehicle.mecha_fault_stacks)
		var/datum/mecha_fault/resolved = GLOB.mecha_faults[path]
		if(!resolved?.id)
			continue
		encoding[resolved.id] = list(
			"name" = resolved.name,
			"desc" = resolved.desc,
			"stacks" = casted_vehicle.mecha_fault_stacks[path],
		)
	return encoding

/datum/vehicle_maint_controller/mecha/proc/queue_update_ui_faults()
	// TODO: queue
	update_ui_faults()

/datum/vehicle_maint_controller/mecha/proc/update_ui_faults()
	push_ui_data(data = list("faults" = encode_ui_faults()))
