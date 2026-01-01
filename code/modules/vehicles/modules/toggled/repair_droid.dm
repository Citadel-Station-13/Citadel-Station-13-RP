//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/vehicle_module/toggled/repair_droid
	name = "repair droid"
	desc = "A repair-drone deployer that can fix some limited amount of damage to the vehicle's components and modules."
	icon = 'icons/modules/vehicles/vehicle_module/droids.dmi'
	icon_state = "repair_droid"
	base_icon_state = "repair_droid"

	vehicle_encumbrance = 2.5

	requires_power_to_stay_active = TRUE

	module_slot = VEHICLE_MODULE_SLOT_HULL

	/// opaque data for overlay. should never be mutated internally, only replaced.
	var/image/overlay_applied

	/// health per second
	var/repair_speed = 1.5
	/// wattage
	/// * our efficiency of joules per hp is effectively this divided by [repair_speed]
	var/repair_power_cost = 2000

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

	// prepare
	var/total_repair = repair_speed * delta_time
	var/remaining_repair = total_repair

	// + chassis
	var/repair_chassis_to = vehicle.integrity_max * vehicle.repair_droid_max_ratio
	if(vehicle.integrity < repair_chassis_to)
		var/chassis_efficiency = vehicle.integrity < vehicle.integrity_failure ? \
		vehicle.repair_droid_recovery_efficiency * vehicle.repair_droid_inbound_efficiency : \
		vehicle.repair_droid_inbound_efficiency

		var/chassis_missing_amount = repair_chassis_to - vehicle.integrity
		var/chassis_fix_amount = min(chassis_missing_amount, remaining_repair)

		vehicle.adjust_integrity(chassis_fix_amount)
		remaining_repair -= chassis_fix_amount
	if(remaining_repair <= 0)
		return

	// + components, ordered
	// TODO: do we want to order this like this?
	var/list/obj/item/vehicle_component/components_to_repair = vehicle.query_repair_droid_components_immutable()
	if(length(components_to_repair))
		for(var/obj/item/vehicle_component/component as anything in components_to_repair)
			var/repair_component_to = component.integrity_max * component.repair_droid_max_ratio
			var/component_efficiency = component.integrity < component.integrity_failure ? \
			component.repair_droid_recovery_efficiency * component.repair_droid_inbound_efficiency : \
			component.repair_droid_inbound_efficiency

			var/component_missing_amount = repair_component_to - component.integrity
			var/component_fix_amount = min(component_missing_amount, remaining_repair)

			component.adjust_integrity(component_fix_amount)
			remaining_repair -= component_fix_amount
			if(remaining_repair <= 0)
				break
	if(remaining_repair <= 0)
		return

	// + modules, ordered
	// TODO: do we want to order this like this?
	var/list/obj/item/vehicle_module/modules_to_repair = vehicle.query_repair_droid_modules_immutable()
	if(length(modules_to_repair))
		for(var/obj/item/vehicle_module/module as anything in modules_to_repair)
			var/repair_module_to = module.integrity_max * module.repair_droid_max_ratio
			var/module_efficiency = module.integrity < module.integrity_failure ? \
			module.repair_droid_recovery_efficiency * module.repair_droid_inbound_efficiency : \
			module.repair_droid_inbound_efficiency

			var/module_missing_amount = repair_module_to - module.integrity
			var/module_fix_amount = min(module_missing_amount, remaining_repair)

			module.adjust_integrity(module_fix_amount)
			remaining_repair -= module_fix_amount
			if(remaining_repair <= 0)
				break
	if(remaining_repair <= 0)
		return

	// watt times time = joules
	var/using_power = repair_power_cost * delta_time * (1 - (remaining_repair / total_repair))
	vehicle.draw_module_power_oneoff(src, using_power)

/obj/item/vehicle_module/toggled/repair_droid/proc/update_vehicle_overlay()
	if(!vehicle)
		return
	var/image/building = image(icon, "[base_icon_state]-vehicle[active ? "-active" : ""]")
	if(overlay_applied)
		vehicle.cut_overlay(overlay_applied, TRUE)
	overlay_applied = building
	vehicle.add_overlay(overlay_applied, TRUE)
