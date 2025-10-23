//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/vehicle_ui_controller
	#warn hook
	var/vehicle_expected_type = /obj/vehicle
	var/obj/vehicle/vehicle
	/// UI interface path
	var/vehicle_ui_path = "vehicle/VehicleController"

/datum/vehicle_ui_controller/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["integrity"] = vehicle.integrity
	.["integrityMax"] = vehicle.integrity_max
	.["name"] = vehicle.name

/datum/vehicle_ui_controller/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["moduleRefs"] = encode_module_refs()
	.["componentRefs"] = encode_component_refs()

/datum/vehicle_ui_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)


/datum/vehicle_ui_controller/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VehicleController")
		ui.open()

/datum/vehicle_ui_controller/ui_nested_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/vehicle_ui_controller/proc/queue_update_component_refs()
	#warn impl

/datum/vehicle_ui_controller/proc/queue_update_module_refs()
	#warn impl

/datum/vehicle_ui_controller/proc/update_component_refs()
	push_ui_data(data = list("componentRefs" = encode_component_refs()))

/datum/vehicle_ui_controller/proc/update_module_refs()
	push_ui_data(data = list("moduleRefs" = encode_module_refs()))

/datum/vehicle_ui_controller/proc/encode_component_refs()
	. = list()
	#warn impl

/datum/vehicle_ui_controller/proc/encode_module_refs()
	. = list()
	#warn impl

#warn impl
