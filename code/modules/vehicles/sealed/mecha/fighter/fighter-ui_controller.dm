//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/vehicle_ui_controller/mecha
	vehicle_expected_type = /obj/vehicle/sealed/mecha
	vehicle_ui_path = "vehicle/mecha/fighter/MechaController"

/datum/vehicle_ui_controller/mecha/fighter/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/vehicle_ui_controller/mecha/fighter/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	var/obj/vehicle/sealed/mecha/fighter/casted_vehicle = vehicle
	.["mCompHullRef"] = casted_vehicle.comp_hull ? ref(casted_vehicle.comp_hull) : null
	.["mCompArmorRef"] = casted_vehicle.comp_armor ? ref(casted_vehicle.comp_armor) : null
	.["strafing"] = casted_vehicle.strafing
	.["lights"] = casted_vehicle.floodlight_active

/datum/vehicle_ui_controller/mecha/fighter/update_component_refs()
	..()
	var/obj/vehicle/sealed/mecha/fighter/casted_vehicle = vehicle
	push_ui_data(data = list(
		"mCompHullRef" = casted_vehicle.comp_hull ? ref(casted_vehicle.comp_hull) : null,
		"mCompArmorRef" = casted_vehicle.comp_armor ? ref(casted_vehicle.comp_armor) : null,
	))

/datum/vehicle_ui_controller/mecha/fighter/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/obj/vehicle/sealed/mecha/fighter/casted_vehicle = vehicle
	switch(action)
		if("toggleStrafing")
			#warn this
			return TRUE
		if("toggleLights")
			#warn this
			return TRUE
		if("toggleRadioBroadcast")
			if(!casted_vehicle.radio)
				return TRUE
			casted_vehicle.radio.broadcasting = !casted_vehicle.radio.broadcasting
			#warn log
			return TRUE
		if("toggleRadioReceive")
			if(!casted_vehicle.radio)
				return TRUE
			casted_vehicle.radio.listening = !casted_vehicle.radio.listening
			#warn log
			return TRUE
		if("setRadioFreq")
			if(!casted_vehicle.radio)
				return TRUE
			var/new_freq = sanitize_frequency(params["freq"])
			casted_vehicle.radio.set_frequency(new_freq)
			#warn log
			return TRUE
		if("setAirtankActive")
			var/desired = params["active"]
			if(desired == casted_vehicle.use_internal_tank)
				return TRUE
			#warn impl; call internal_tank()
			return TRUE
		if("connectAtmosPort")
			#warn feedback & log
			return TRUE
		if("disconnectAtmosPort")
			#warn feedback & log
			return TRUE
		if("toggleIdUploadLock")
			#warn feedback & log
			return TRUE
		if("toggleMaintPanelLock")
			#warn feedback & log
			return TRUE
		if("setDisplayName")
			var/desiredRaw = params["name"]
			var/desired = sanitizeSafe(desiredRaw, MAX_NAME_LEN)
			if(!length(desired))
				return TRUE
			var/old_name = casted_vehicle.name
			casted_vehicle.name = desired
			casted_vehicle.vehicle_log_for_admins(actor, "renamed", list("oldName" = old_name, "newName" = desired))
			return TRUE

/datum/vehicle_ui_controller/mecha/fighter/ui_nested_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/vehicle_ui_controller/mecha/fighter/proc/update_ui_strafing()
	var/obj/vehicle/sealed/mecha/fighter/casted_vehicle = vehicle
	push_ui_data(list("data" = casted_vehicle.strafing))

/datum/vehicle_ui_controller/mecha/fighter/proc/update_ui_floodlights()
	var/obj/vehicle/sealed/mecha/fighter/casted_vehicle = vehicle
	push_ui_data(list("lights" = casted_vehicle.floodlight_active))

/datum/vehicle_ui_controller/mecha/fighter/proc/encode_ui_faults()

/datum/vehicle_ui_controller/mecha/fighter/proc/queue_update_ui_faults()
	// TODO: queue
	update_ui_faults()

/datum/vehicle_ui_controller/mecha/fighter/proc/update_ui_faults()


#warn impl
