//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/vehicle_module
	//* Module *//
	/// currently active chassis
	var/obj/vehicle/vehicle
	/// Unremoveable? Won't be able to be salvaged if this is set to TRUE.
	var/intrinsic = FALSE
	/// Slot, if any
	var/module_slot
	/// Classes
	var/module_class = NONE
	/// dedupe?
	var/disallow_duplicates = FALSE
	/// dedupe type? if set, use that type and subtypes; otherwise uses exact path
	/// * generally needs to be set if [disallow_duplicates] is
	#warn check this in vehicle
	var/disallow_duplicates_match_type

	//* UI *//
	/// UI component key when being rendered
	/// * Must route to a valid component in vehicle UI routing. Check TGUI folder for more info.
	var/ui_component = "Trivial"

/obj/item/vehicle_module/proc/fits_on_vehicle(obj/vehicle/vehicle, vehicle_opinion, vehicle_is_full, datum/event_args/actor/actor, silent)
	return vehicle_opinion && !vehicle_is_full

/obj/item/vehicle_module/proc/on_install(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/obj/item/vehicle_module/proc/on_uninstall(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/**
 * Supports clicking?
 */
/obj/item/vehicle_module/proc/is_potential_active_click_module()
	return FALSE
	#warn hook

/obj/item/vehicle_module/proc/is_active_click_module()
	if(!vehicle)
		return FALSE
	#warn impl

//* Chassis - Physicality *//

/**
 * Returns if our mount is sufficiently close to something to be considered adjacent.
 *
 * * This is usually our mech.
 * * If we are not mounted, this always fails.
 */
/obj/item/vehicle_module/proc/sufficiently_adjacent(atom/entity)
	return chassis?.sufficiently_adjacent(entity)

#warn this
/obj/item/vehicle_module/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	return receive_using_item_on(using, clickchain, clickchain_flags)

//* Interactions *//

#warn this
/**
 * Called to handle item attack chain (using_item_on) on our chassis (whether that's a vehicle or something else)
 * or a normal item attack chain
 *
 * @params
 * * using - the item
 * * clickchain - clickchain data
 * * clickchain_flags - clickchain flags
 * * from_mounted_on - the thing actually receiving the click. null if it's from our own using_item_on.
 *
 * @return CLICKCHAIN_* flags
 */
/obj/item/vehicle_module/proc/receive_using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags, atom/movable/from_mounted_on)
	SHOULD_NOT_SLEEP(TRUE)
	return clickchain_flags
	#warn hook on chassis

//* Logging *//

#warn make logging procs

//* Usage - World *//

#warn this
/**
 * Called when being used by a pilot on the world.
 * * This is a very complex binding because we are not necessarily mounted or used by a vehicle
 *   when this happens.
 * * We can, however, expect that we are properly item-mounted; use abstraction procs as needed
 *   for power-draw and whatnot.
 *
 * @params
 * * mounted_on - what to treat as the root object. this is a mob if it's mounted on a rigsuit, ourselves
 *                if we're not ontop of anything, a vehicle if we're on a vehicle, etc. This should only be
 *                used for adjacency checks in general; avoid using typecasts or directly accessing this.
 * * clickchain - data of the click.
 *
 * @return CLICKCHAIN_* flags
 */
/obj/item/vehicle_module/proc/module_attack_chain(atom/movable/mounted_on, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return clickchain_flags

//* UI *//

/obj/item/vehicle_module/proc/vehicle_ui_module_data()
	return list(
		"integrity" = integrity,
		"integrityMax" = integrity_max,
		"name" = name,
		"desc" = desc,
		"ref" = ref(src),
		"integrityUsed" = TRUE,
		"isPotentialActiveClickModule" = is_potential_active_click_module(),
		"allowEject" = !intrinsic,
		"tguiRoute" = ui_component,
	)

/obj/item/vehicle_module/proc/vehicle_ui_module_push(list/data)

/**
 * @return TRUE to update data (not static data)
 */
/obj/item/vehicle_module/proc/vehicle_ui_module_act(action, list/params, datum/event_args/actor/actor)

/**
 * Supertype of shieldcalls that handle vehicle hits. Just subtype one
 * and set the path on your component to use them.
 */
/datum/shieldcall/bound/vehicle_module
	expected_type = /obj/vehicle

/datum/armor/vehicle_module
