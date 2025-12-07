//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * * integrity failure is full failure.
 */
/obj/item/vehicle_module
	name = "vehicle module"
	desc = "Presumably something you attach to a vehicle. What is this?"
	#warn sprite

	integrity = 200
	integrity_max = 200
	integrity_failure = 100

	vehicle_encumbrance = 1
	weight = 3
	w_class = WEIGHT_CLASS_BULKY

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
	/// vehicle encumbrance
	var/vehicle_encumbrance = 0

	//* Install *//
	/// Tool behavior needed to remove us
	var/remove_tool = TOOL_SCREWDRIVER
	/// Time to remove us
	var/remove_time = 0

	//* Click *//
	/// click half-arc from forward of mech
	/// * 45 is a 90 deg arc centered on front, 90 is a 180.
	var/click_restrain_half_angle = 60

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

/obj/item/vehicle_module/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("[src] will [module_slot ? "the [module_slot]" : "any"] slot.")

/obj/item/vehicle_module/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	return receive_using_item_on(using, clickchain, clickchain_flags)

/obj/item/vehicle_module/proc/fits_on_vehicle(obj/vehicle/vehicle, vehicle_opinion, vehicle_is_full, datum/event_args/actor/actor, silent)
	return vehicle_opinion && !vehicle_is_full

/obj/item/vehicle_module/proc/on_install(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/obj/item/vehicle_module/proc/on_uninstall(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/obj/item/vehicle_module/proc/can_be_removed()
	return !intrinsic

/**
 * Supports clicking?
 */
/obj/item/vehicle_module/proc/is_potential_active_click_module()
	return FALSE

/obj/item/vehicle_module/proc/is_active_click_module()
	if(!vehicle)
		return FALSE
	return vehicle.module_active_click == src

/obj/item/vehicle_module/proc/set_vehicle_encumbrance(new_value)
	. = vehicle_encumbrance
	vehicle_encumbrance = new_value
	on_vehicle_encumbrance_change(., new_value)
	. = null

/obj/item/vehicle_module/proc/on_vehicle_encumbrance_change(old_value, new_value)
	vehicle?.total_module_encumbrance += (new_value - old_value)
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
/obj/item/vehicle_module/proc/vehicle_do_after(
	datum/event_args/actor/actor,
	delay,
	atom/target,
	flags,
	max_distance,
	datum/callback/additional_checks
)
	if(!vehicle)
		return FALSE
	return do_vehicle(vehicle, delay, target, flags, max_distance, CALLBACK(src, PROC_REF(vehicle_do_after_cb), additional_checks))

/obj/item/vehicle_module/proc/vehicle_do_after_cb(datum/callback/additional_checks, list/do_after_args)
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
	sfx_vary
)
	. = vehicle_do_after(actor, delay, target, flags, max_distance, additional_checks)
	if(.)
		playsound(
			vehicle,
			isnull(sfx) ? sound_do_after_default : sfx,
			isnull(sfx_vol) ? sound_do_after_default_volume : sfx_vol,
			isnull(sfx_vary) ? sound_do_after_default_vary : sfx_vary,
		)

//* Chassis - Physicality *//

/**
 * Returns if our mount is sufficiently close to something to be considered adjacent.
 *
 * * This is usually our vehicle.
 * * If we are not mounted, this always fails.
 */
/obj/item/vehicle_module/proc/sufficiently_adjacent(atom/entity)
	return vehicle?.sufficiently_adjacent(entity)

//* Click *//

/obj/item/vehicle_module/proc/on_vehicle_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return clickchain_flags

/**
 * Call this to hook in any target scrambling, like from inherent inaccuracy / damage.
 */
/obj/item/vehicle_module/proc/request_click_target_scrmabling(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return vehicle ? vehicle.request_click_target_scrmabling(target, clickchain, clickchain_flags) : target

/**
 * Call this to hook in any target scrambling, like from inherent inaccuracy / damage.
 */
/obj/item/vehicle_module/proc/request_click_angle_scrmabling(angle, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return vehicle ? vehicle.request_click_angle_scrmabling(target, clickchain, clickchain_flags) : angle

//* Interactions *//

/**
 * Checks if we're interested in handling a click. This is used so the user
 * can radial for which module wants to receive it.
 * * This doesn't mean a user can't use an item if this returns FALSE! The normal `using_item_on` can still be used.
 */
#warn hook
/obj/item/vehicle_module/proc/interested_using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags, atom/movable/from_mounted_on)
	return FALSE

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

/**
 * * Anything fed in here is sent to game logs.
 * * Includes ckeys.
 */
/obj/item/vehicle_module/proc/vehicle_log_for_admins(datum/event_args/actor/actor, action, list/params)
	log_game("VEHICLE-MODULE: [src] ([ref(src)]) ([type])[vehicle ? " @ [vehicle] ([ref(vehicle)])" : ""] - [actor.actor_log_string()]: [action][params ? " - [json_encode(params)]" : ""]")

/**
 * * Eventually used to allow things like mechs to maintain internal logs.
 * * Anything fed in here is IC. Don't leak ckeys.
 */
/obj/item/vehicle_module/proc/vehicle_log_for_fluff_ic()
	CRASH("not implemented")

//* Occupants / Feedback *//

#warn does this work icon wise?
/obj/item/vehicle_module/proc/vehicle_occupant_send_default_chat(html)
	vehicle?.occupant_send_default_chat("<img src=\"\ref[src]\"> [html]")

/obj/item/vehicle_module/proc/vehicle_occupant_send_chat(html)
	vehicle?.occupant_send_chat(html)

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

//* Defense & Interactions *//

/obj/item/vehicle_module/emp_act(severity)
	..()
	on_emp(EMP_LEGACY_SEVERITY_TO_POWER(severity))

/obj/item/vehicle_module/proc/on_emp(power, from_vehicle)
	#warn impl

/obj/item/vehicle_module/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()

#warn impl; repairs? emp?

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
	vehicle.ui_controller?.push_ui_nested_data(updates = list(ref(src) = data))

/**
 * @return TRUE to stop propagation
 */
/obj/item/vehicle_module/proc/vehicle_ui_module_act(action, list/params, datum/event_args/actor/actor)
	return FALSE

/obj/item/vehicle_module/proc/vehicle_ui_maint_data()
	return list(
		"removeTool" = remove_tool,
		"removeTime" = remove_time,
		"integrity" = integrity,
		"integrityMax" = integrity_max,
		"name" = name,
		"desc" = desc,
		"ref" = ref(src),
		"allowEject" = !intrinsic,
	)

/**
 * @return TRUE to stop propagation
 */
/obj/item/vehicle_module/proc/vehicle_ui_maint_act(action, list/params, datum/event_args/actor/actor)
	return FALSE

/obj/item/vehicle_module/proc/vehicle_ui_maint_push(list/data)
	vehicle?.maint_controller?.push_ui_nested_data(updates = list(ref(src) = data))

/**
 * Supertype of shieldcalls that handle vehicle hits. Just subtype one
 * and set the path on your component to use them.
 */
/datum/shieldcall/bound/vehicle_module
	expected_type = /obj/vehicle

/datum/armor/vehicle_module
