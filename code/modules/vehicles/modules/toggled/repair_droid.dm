//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/vehicle_module/toggled/repair_droid
	name = "repair droid"
	desc = "A repair-drone deployer that can fix some limited amount of damage to the vehicle's components and modules."
	#warn sprite

	vehicle_encumbrance = 2.5

	module_slot = VEHICLE_MODULE_SLOT_HULL

	/// opaque data for overlay. should never be mutated internally, only replaced.
	var/image/overlay_applied

	/// health per second
	var/repair_speed = 1.5
	/// wattage
	var/repair_power_cost = 1000

#warn impl

/obj/item/vehicle_module/toggled/repair_droid/on_install(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	..()
	update_vehicle_overlay()

/obj/item/vehicle_module/toggled/repair_droid/on_uninstall(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	..()
	if(overlay_applied)
		vehicle.cut_overlay(overlay_applied, TRUE)

/obj/item/vehicle_module/toggled/repair_droid/on_activate(datum/event_args/actor/actor, silent)
	..()
	START_PROCESSING(SSobj, src)
	update_vehicle_overlay()

/obj/item/vehicle_module/toggled/repair_droid/on_deactivate(datum/event_args/actor/actor, silent)
	..()
	STOP_PROCESSING(SSobj, src)
	update_vehicle_overlay()

/obj/item/vehicle_module/toggled/repair_droid/process(delta_time)
	if(!active)
		return PROCESS_KILL
	if(!vehicle)
		return PROCESS_KILL
	// repair processes:

	// + chassis --> ordered components
	#warn take into account repair_droid_recovery_efficiency
	#warn take into account integrity_failure
	var/chassis_step_remaining = repair_speed
	if(vehicle.integrity < vehicle.integrity_max * vehicle.repair_droid_max_ratio)
		var/chassis_efficiency = vehicle.repair_droid_inbound_efficiency
		if(vehicle.integrity < vehicle.integrity_failure)
			chassis_efficiency *= vehicle.repair_droid_recovery_efficiency

	if(chassis_step_remaining)
		var/list/obj/item/vehicle_component/components_to_repair = vehicle.query_repair_droid_components_immutable()
		if(length(components_to_repair))
			for(var/obj/item/vehicle_component/c)

	// + modules all at once
	var/list/obj/item/vehicle_module/modules_to_repair = vehicle.query_repair_droid_modules_immutable()
	if(length(modules_to_repair))
		var/list/obj/item/vehicle_module/modules_needing_repair = list()
		for(var/obj/item/vehicle_module/module in modules_to_repair)
			if(module.integrity < module.integrity_max * module.repair_droid_max_ratio)

/obj/item/vehicle_module/toggled/repair_droid/proc/update_vehicle_overlay()
	if(!vehicle)
		return
	var/image/building = image(icon, "[base_icon_state]-vehicle[active ? "-active" : ""]")
	if(overlay_applied)
		vehicle.cut_overlay(overlay_applied, TRUE)
	overlay_applied = building
	vehicle.add_overlay(overlay_applied, TRUE)

#warn impl
