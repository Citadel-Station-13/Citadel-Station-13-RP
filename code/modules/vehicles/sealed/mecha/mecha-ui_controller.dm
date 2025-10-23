//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/vehicle_ui_controller/mecha
	vehicle_expected_type = /obj/vehicle/sealed/mecha
	vehicle_ui_path = "vehicle/mecha/MechaController"

/datum/vehicle_ui_controller/mecha/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/vehicle_ui_controller/mecha/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	var/obj/vehicle/sealed/mecha/casted_vehicle = vehicle
	.["mCompHullRef"] = casted_vehicle.comp_hull ? ref(casted_vehicle.comp_hull) : null
	.["mCompArmorRef"] = casted_vehicle.comp_armor ? ref(casted_vehicle.comp_armor) : null
	.["strafing"] = casted_vehicle.strafing

/datum/vehicle_ui_controller/mecha/update_component_refs()
	..()
	var/obj/vehicle/sealed/mecha/casted_vehicle = vehicle
	push_ui_data(data = list(
		"mCompHullRef" = casted_vehicle.comp_hull ? ref(casted_vehicle.comp_hull) : null,
		"mCompArmorRef" = casted_vehicle.comp_armor ? ref(casted_vehicle.comp_armor) : null,
	))

/datum/vehicle_ui_controller/mecha/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("toggleStrafing")
			#warn this
			return TRUE

/datum/vehicle_ui_controller/mecha/ui_nested_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/vehicle_ui_controller/mecha/proc/update_ui_strafing()
	var/obj/vehicle/sealed/mecha/casted_vehicle = vehicle
	push_ui_data(list("data" = casted_vehicle.strafing))

#warn impl
