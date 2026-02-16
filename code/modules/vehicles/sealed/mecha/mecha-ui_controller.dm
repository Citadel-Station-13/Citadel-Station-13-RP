//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/vehicle_ui_controller/mecha
	vehicle_expected_type = /obj/vehicle/sealed/mecha
	vehicle_ui_path = "vehicle/mecha/MechaController"

/datum/vehicle_ui_controller/mecha/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	var/obj/vehicle/sealed/mecha/casted_vehicle = vehicle
	.["portConnected"] = !!casted_vehicle.connected_port

	#warn impl
	// <b>Powercell charge: </b>[isnull(cell_charge)?"No powercell installed":"[obj_cell_slot?.cell?.percent()]%"]<br>
	// <b>Air source: </b>[use_internal_tank?"Internal Airtank":"Environment"]<br>
	// <b>Airtank pressure: </b>[tank_pressure]kPa<br>
	// <b>Airtank temperature: </b>[tank_temperature]K|[tank_temperature - T0C]&deg;C<br>
	// <b>Cabin pressure: </b>[cabin_pressure>WARNING_HIGH_PRESSURE ? "<font color='red'>[cabin_pressure]</font>": cabin_pressure]kPa<br>
	// <b>Cabin temperature: </b> [return_temperature()]K|[return_temperature() - T0C]&deg;C<br>

/datum/vehicle_ui_controller/mecha/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	var/obj/vehicle/sealed/mecha/casted_vehicle = vehicle
	.["mCompHullRef"] = casted_vehicle.comp_hull ? ref(casted_vehicle.comp_hull) : null
	.["mCompArmorRef"] = casted_vehicle.comp_armor ? ref(casted_vehicle.comp_armor) : null
	.["strafing"] = casted_vehicle.strafing
	.["lights"] = casted_vehicle.floodlight_active

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
	var/obj/vehicle/sealed/mecha/casted_vehicle = vehicle
	switch(action)
		if("toggleStrafing")
			casted_vehicle.user_set_strafing(actor, !casted_vehicle.strafing)
			return TRUE
		if("toggleLights")
			casted_vehicle.user_set_floodlights(actor, !casted_vehicle.floodlight_active)
			return TRUE
		if("toggleRadioBroadcast")
			if(!casted_vehicle.radio)
				return TRUE
			casted_vehicle.radio.broadcasting = !casted_vehicle.radio.broadcasting
			casted_vehicle.vehicle_log_for_admins(actor, "radio-broadcast", list("active" = casted_vehicle.radio.broadcasting))
			return TRUE
		if("toggleRadioReceive")
			if(!casted_vehicle.radio)
				return TRUE
			casted_vehicle.radio.listening = !casted_vehicle.radio.listening
			casted_vehicle.vehicle_log_for_admins(actor, "radio-listen", list("active" = casted_vehicle.radio.broadcasting))
			return TRUE
		if("setRadioFreq")
			if(!casted_vehicle.radio)
				return TRUE
			var/new_freq = sanitize_frequency(params["freq"])
			casted_vehicle.radio.set_frequency(new_freq)
			casted_vehicle.vehicle_log_for_admins(actor, "radio-freq", list("freq" = casted_vehicle.radio.frequency))
			return TRUE
		if("setAirtankActive")
			var/desired = params["active"]
			if(desired == casted_vehicle.use_internal_tank)
				return TRUE
			#warn impl; call internal_tank()
			return TRUE
		if("connectAtmosPort")
			casted_vehicle.connect_to_port()
			return TRUE
		if("disconnectAtmosPort")
			casted_vehicle.disconnect_from_port()
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

/datum/vehicle_ui_controller/mecha/ui_nested_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/vehicle_ui_controller/mecha/proc/update_ui_strafing()
	var/obj/vehicle/sealed/mecha/casted_vehicle = vehicle
	push_ui_data(list("strafing" = casted_vehicle.strafing))

/datum/vehicle_ui_controller/mecha/proc/update_ui_floodlights()
	var/obj/vehicle/sealed/mecha/casted_vehicle = vehicle
	push_ui_data(list("lights" = casted_vehicle.floodlight_active))

/datum/vehicle_ui_controller/mecha/proc/encode_ui_faults()

/datum/vehicle_ui_controller/mecha/proc/queue_update_ui_faults()
	// TODO: queue
	update_ui_faults()

/datum/vehicle_ui_controller/mecha/proc/update_ui_faults()


#warn impl
