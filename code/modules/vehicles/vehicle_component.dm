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
	vehicle_encumbrance = 1.0
	weight = 4.5

	//* Component *//
	/// currently active chassis
	var/obj/vehicle/vehicle
	/// Unremoveable? Won't be able to be salvaged if this is set to TRUE.
	var/intrinsic = FALSE
	/// vehicle encumbrance
	var/vehicle_encumbrance = 0

	//* Binding *//
	/// bind shieldtype type; must be a path of /datum/shieldcall/bound/vehicle_component if set.
	var/autobind_shieldcall_type
	var/datum/shieldcall/bound/vehicle_component/autobind_shieldcall

	//* Repairs *//
	/// Repair droid efficiency
	/// * This is relative difficulty. 2 means twice the power / material!
	var/repair_droid_inbound_efficiency = 0.5
	/// Repair droid max ratio to heal. Repair droids won't heal us above this of our max integrity minus failure integrity.
	/// * This includes `integrity_failure`!
	var/repair_droid_max_ratio = 0.75
	/// Additional repair droid efficiency, as multiplier, if already broken.
	var/repair_droid_recovery_efficiency = 2.5

	//* Sounds *//
	/// Default sound to play after a `vehicle_do_after_and_sound`, if any
	var/sound_do_after_default
	var/sound_do_after_default_volume = 75
	var/sound_do_after_default_vary = TRUE

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

/obj/item/vehicle_component/proc/can_be_removed()
	return !intrinsic

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

/obj/item/vehicle_component/proc/set_vehicle_encumbrance(new_value)
	. = vehicle_encumbrance
	vehicle_encumbrance = new_value
	on_vehicle_encumbrance_change(., new_value)
	. = null

/obj/item/vehicle_component/proc/on_vehicle_encumbrance_change(old_value, new_value)
	vehicle?.total_component_encumbrance += (new_value - old_value)
	vehicle.update_movespeed_vehicle_encumbrance()

/**
 * Does an action after a delay. This is basically `do_after` but for vehicles.
 *
 * TODO: set progressbar delay to target delay or otherwise be able to reuse progressbar?
 *
 * @params
 * * actor - initiating actor
 * * delay - how long in deciseconds
 * * target - targeted atom, if any
 * * flags - do_after flags as specified in [code/__DEFINES/procs/do_after.dm]
 * * max_distance - if not null, the user is required to be get_dist() <= max_distance from target.
 * * additional_checks - a callback that allows for custom checks. this is invoked with our args directly, allowing us to modify delay.
 */
/obj/item/vehicle_component/proc/vehicle_do_after(
	datum/event_args/actor/actor,
	delay,
	atom/target,
	flags,
	max_distance,
	datum/callback/additional_checks,
)
	if(!vehicle)
		return FALSE
	return do_vehicle(vehicle, delay, target, flags, max_distance, CALLBACK(src, PROC_REF(vehicle_do_after_cb), additional_checks))

/obj/item/vehicle_component/proc/vehicle_do_after_cb(datum/callback/additional_checks, list/do_after_args)
	if(QDELETED(src) || do_after_args[DO_VEHICLE_ARG_VEHICLE] != vehicle)
		return FALSE
	return additional_checks?.Invoke(do_after_args)

/**
 * `vehicle_do_after` and play a sound on success
 */
/obj/item/vehicle_module/proc/vehicle_do_after_and_sound(
	datum/event_args/actor/actor,
	delay,
	atom/target,
	flags,
	max_distance,
	datum/callback/additional_checks,
	sfx,
	sfx_vol,
	sfx_vary,
)
	. = vehicle_do_after(actor, delay, target, flags, max_distance, additional_checks)
	if(.)
		playsound(
			vehicle,
			isnull(sfx) ? sound_do_after_default : sfx,
			isnull(sfx_vol) ? sound_do_after_default_volume : sfx_vol,
			isnull(sfx_vary) ? sound_do_after_default_vary : sfx_vary,
		)

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
	vehicle.ui_controller?.push_ui_nested_data(updates = list(ref(src) = data))

/obj/item/vehicle_component/proc/vehicle_ui_component_act(action, list/params, datum/event_args/actor/actor)
	return FALSE

/**
 * Supertype of shieldcalls that handle vehicle hits. Just subtype one
 * and set the path on your component to use them.
 */
/datum/shieldcall/bound/vehicle_component
	expected_type = /obj/vehicle
