//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/vehicle_maint_controller
	#warn hook
	var/vehicle_expected_type = /obj/vehicle
	var/obj/vehicle/vehicle
	/// UI interface path
	var/vehicle_ui_path = "vehicle/VehicleMaintController"

	var/queued_component_ref_update = FALSE
	var/queued_module_ref_update = FALSE

/datum/vehicle_maint_controller/New(obj/vehicle/vehicle)
	src.vehicle = vehicle

/datum/vehicle_maint_controller/Destroy()
	if(vehicle.maint_controller == src)
		vehicle.maint_controller = null
	return ..()

#warn impl all

/datum/vehicle_maint_controller/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["integrity"] = vehicle.integrity
	.["integrityMax"] = vehicle.integrity_max
	.["name"] = vehicle.name
	.["panelOpen"] = vehicle.maint_panel_open
	.["panelBroken"] = !vehicle.maint_panel || (vehicle.maint_panel.atom_flags & ATOM_BROKEN)
	.["panelLocked"] = vehicle.maint_panel_locked

/datum/vehicle_maint_controller/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["moduleRefs"] = encode_module_refs()
	.["componentRefs"] = encode_component_refs()

/datum/vehicle_maint_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(params["__routeModule"])
		var/obj/item/vehicle_module/t_route = locate(params["__routeComponent"]) in vehicle.modules
		t_route.vehicle_ui_module_act(action, params, actor)
		return TRUE
	if(params["__routeComponent"])
		var/obj/item/vehicle_component/t_route = locate(params["__routeComponent"]) in vehicle.components
		t_route.vehicle_ui_component_act(action, params, actor)
		return TRUE
	switch(action)
		if("removeModule")
			var/ref = params["ref"]
			if(!istext(ref) || !length(ref))
				return TRUE
			var/obj/item/vehicle_module/to_eject = locate(ref) in vehicle.modules
			if(!to_eject)
				return TRUE
			#warn impl
			return TRUE
		if("removeComponent")
			var/ref = params["ref"]
			if(!istext(ref) || !length(ref))
				return TRUE
			var/obj/item/vehicle_component/to_eject = locate(ref) in vehicle.components
			if(!to_eject)
				return TRUE
			#warn impl
			return TRUE
		if("closePanel")
		if("openPanel")
		if("unlockPanel")
		if("lockPanel")
	#warn impl all

/datum/vehicle_maint_controller/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, vehicle_ui_path)
		ui.open()

/datum/vehicle_maint_controller/ui_nested_data(mob/user, datum/tgui/ui)
	. = ..()
	for(var/obj/item/vehicle_module/encoding as anything in vehicle.modules)
		.[ref(encoding)] = encoding.vehicle_ui_module_data()
	for(var/obj/item/vehicle_component/encoding as anything in vehicle.components)
		.[ref(encoding)] = encoding.vehicle_ui_component_data()

/datum/vehicle_maint_controller/ui_state(mob/user)
	. = ..()
	#warn impl

/datum/vehicle_maint_controller/proc/queue_update_component_refs()
	if(queued_component_ref_update)
		return
	queued_component_ref_update = TRUE
	addtimer(CALLBACK(src, PROC_REF(update_component_refs)), 0)

/datum/vehicle_maint_controller/proc/update_component_refs()
	queued_component_ref_update = FALSE
	push_ui_data(data = list("componentRefs" = encode_component_refs()))

/datum/vehicle_maint_controller/proc/queue_update_module_refs()
	if(queued_module_ref_update)
		return
	queued_module_ref_update = TRUE
	addtimer(CALLBACK(src, PROC_REF(update_module_refs)), 0)

/datum/vehicle_maint_controller/proc/update_module_refs()
	queued_module_ref_update = FALSE
	push_ui_data(data = list("moduleRefs" = encode_module_refs()))

/datum/vehicle_maint_controller/proc/encode_component_refs()
	. = list()
	for(var/obj/item/vehicle_component/encoding as anything in vehicle.components)
		. += ref(encoding)

/datum/vehicle_maint_controller/proc/encode_module_refs()
	. = list()
	for(var/obj/item/vehicle_module/encoding as anything in vehicle.modules)
		. += ref(encoding)
