//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * * Integrity failure is full failure.
 */
/obj/item/vehicle_component
	name = "vehicle component"
	desc = "Some kind of component that presumably goes on some kind of vehicle."

	integrity = 200
	integrity_max = 200
	integrity_failure = 100

	//* Component *//
	/// currently active chassis
	var/obj/vehicle/vehicle
	/// Unremoveable? Won't be able to be salvaged if this is set to TRUE.
	var/intrinsic = FALSE

	//* Binding *//
	/// bind shieldtype type; must be a path of /datum/shieldcall/bound/vehicle_component if set.
	var/autobind_shieldcall_type
	var/datum/shieldcall/bound/vehicle_component/autobind_shieldcall

	//* Repairs *//
	/// Repair droid efficiency
	/// * This is relative difficulty. 2 means twice the power / material!
	var/repair_droid_inbound_efficiency = 0.5
	/// Repair droid max ratio to heal
	var/repair_droid_max_ratio = 0.5

	//* UI *//
	/// UI component key when being rendered
	/// * Must route to a valid component in vehicle UI routing. Check TGUI folder for more info.
	var/ui_component = "Trivial"

/obj/item/vehicle_component/proc/fits_on_vehicle(obj/vehicle/vehicle, vehicle_opinion, datum/event_args/actor/actor, silent)
	return vehicle_opinion

/obj/item/vehicle_component/proc/on_install(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/obj/item/vehicle_component/proc/on_uninstall(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

#warn impl

/**
 * @return string
 */
/obj/item/vehicle_component/proc/examine_render_name(datum/event_args/examine/examine)
	return name

/**
 * @return list or string
 */
/obj/item/vehicle_component/proc/examine_render_on_vehicle(datum/event_args/examine/examine)
	var/integrity_string = examine_render_integrity(examine)
	return "It has [examine_render_name(examine)] attached.[integrity_string ? " [integrity_string]" : ""]"

/obj/item/vehicle_component

/obj/item/vehicle_component

/obj/item/vehicle_component

/obj/item/vehicle_component

/obj/item/vehicle_component

//* UI *//

/obj/item/vehicle_component/proc/vehicle_ui_component_data()
	return list(
		"name" = name,
		"desc" = desc,
		"ref" = ref(src),
		"integrity" = integrity,
		"integrityMax" = integrity_max,
		"integrityUsed" = TRUE,
		"tguiRoute" = ui_component,
	)

/obj/item/vehicle_component/proc/vehicle_ui_component_push(list/data)

/obj/item/vehicle_component/proc/vehicle_ui_component_act(action, list/params, datum/event_args/actor/actor)

/**
 * Supertype of shieldcalls that handle vehicle hits. Just subtype one
 * and set the path on your component to use them.
 */
/datum/shieldcall/bound/vehicle_component
	expected_type = /obj/vehicle
