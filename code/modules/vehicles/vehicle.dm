//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

TYPE_REGISTER_SPATIAL_GRID(/obj/vehicle, SSspatial_grids.vehicles)
/**
 * generic, multiseat-capable vehicles system
 *
 * ## Concepts
 * * The 'chassis' is ourselves. Chassis armor / integrity are handled via atom integrity.
 *   This may change in the future, so use wrappers in `vehicle-defense.dm`
 */
/obj/vehicle
	//* Components *//
	/// Installed components
	/// * Lazy list.
	var/list/obj/item/vehicle_component/components

	//* Movement *//
	/// Next move
	var/move_next_time = 0
	/// Base movement speed, in tile/seconds
	var/move_base_speed = 5

	//*                          Movespeed                           *//
	//* This will be removed once /obj/vehicle becomes /mob/vehicle! *//
	//*             For now we use the same API mobs do!             *//
	/// List of movement speed modifiers applying to this mob
	/// * This is a lazy list.
	var/list/movespeed_modifiers
	/// List of movement speed modifiers ignored by this mob. List -> List (id) -> List (sources)
	/// * This is a lazy list.
	var/list/movespeed_modifier_immunities
	/// The calculated mob speed slowdown based on the modifiers list
	var/movespeed_hyperbolic

	//* Occupants *//
	/// list of mobs associated to their control flags
	var/list/mob/occupants

	//* Occupants - Actions *//
	/// actions to give everyone; set to typepaths to init
	///
	/// * all of these must be /datum/action/vehicle's
	var/list/occupant_actions

	//* Occupants - HUDs *//
	/// list of typepaths or ids of /datum/atom_hud_providers that occupants with [VEHICLE_CONTROL_USE_HUDS] get added to their perspective
	var/list/occupant_huds

/obj/vehicle/Initialize(mapload)
	. = ..()
	create_initial_components()

//* Actions *//

/obj/vehicle/proc/initialize_occupant_actions()
	for(var/i in 1 to length(occupant_actions))
		var/datum/action/vehicle/actionlike = occupant_actions[i]
		if(istype(actionlike))
		else if(ispath(actionlike))
			occupant_actions[i] = new actionlike(src)

/obj/vehicle/proc/add_occupant_action(datum/action/vehicle/action)
	if(action in occupant_actions)
		return
	occupant_actions += action
	for(var/mob/occupant as anything in occupants)
		if(action.required_control_flags && !(occupants[occupant] & action.required_control_flags))
			continue
		occupant.actions_controlled.add_action(action)

/obj/vehicle/proc/remove_occupant_action(datum/action/vehicle/action)
	if(!(action in occupant_actions))
		return
	occupant_actions -= action
	for(var/mob/occupant as anything in occupants)
		occupant.actions_controlled.remove_action(action)

//* HUDs *//

// todo: clear_occupant_huds()
// todo: add_occupant_hud(datum/atom_hud/hud_like)
// todo: remove_occupant_hud(datum/atom_hud/hud_like)
// todo: resolve_occupant_huds() - make sure list is instances, not ids; needed to dedupe and resolve for add/remove

//* Control Flags *//

/**
 * called when someone is added to the vehicle as well; all additional flags are added then
 */
/obj/vehicle/proc/add_control_flags(mob/controller, flags)
	if(!istype(controller) || !flags)
		return FALSE
	occupants[controller] |= flags
	for(var/i in GLOB.bitflags)
		if(flags & i)
			grant_controller_actions_by_flag(controller, i)
	on_change_control_flags(controller, flags_added = flags)
	return TRUE

/**
 * called when someone exits the vehicle as well; all remaining flags are removed then
 */
/obj/vehicle/proc/remove_control_flags(mob/controller, flags)
	if(!istype(controller) || !flags)
		return FALSE
	occupants[controller] &= ~flags
	for(var/i in GLOB.bitflags)
		if(flags & i)
			remove_controller_actions_by_flag(controller, i)
	on_change_control_flags(controller, flags_removed = flags)
	return TRUE

/**
 * called to hook control flag changes
 */
/obj/vehicle/proc/on_change_control_flags(mob/controller, flags_added, flags_removed)
	if(flags_added & flags_removed)
		stack_trace("some flag was both added and removed. how and why?")
		flags_added &= ~flags_removed
	if(flags_added & VEHICLE_CONTROL_USE_HUDS)
		var/datum/perspective/their_perspective = controller.get_perspective()
		for(var/provider in occupant_huds)
			their_perspective.add_atom_hud(provider, ATOM_HUD_SOURCE_VEHICLE(src))
	if(flags_removed & VEHICLE_CONTROL_USE_HUDS)
		var/datum/perspective/their_perspective = controller.get_perspective()
		for(var/provider in occupant_huds)
			their_perspective.remove_atom_hud(provider, ATOM_HUD_SOURCE_VEHICLE(src))
	for(var/datum/action/vehicle/action as anything in occupant_actions)
		if(action.required_control_flags & flags_added)
			action.grant(controller.actions_controlled)
		else if(action.required_control_flags & flags_removed)
			action.revoke(controller.actions_controlled)

//* Occupants *//

/obj/vehicle/proc/is_occupant(mob/M)
	return !isnull(occupants[M])

/**
 * Call to add a mob to occupants
 *
 * * this should usually be internally called by the specific abstraction of vehicles underneath our path
 */
/obj/vehicle/proc/add_occupant(mob/adding, control_flags)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!istype(adding) || occupants[adding])
		return FALSE
	occupants[adding] = NONE
	add_control_flags(adding, control_flags)
	grant_passenger_actions(adding)
	// add only ones without flags; add_control_flags() handles the ones with
	for(var/datum/action/vehicle/action as anything in occupant_actions)
		if(action.required_control_flags)
			continue
		action.grant(adding.actions_controlled)
	// call added hook
	occupant_added(adding, new /datum/event_args/actor(adding), occupants[adding], FALSE)
	return TRUE

/**
 * Called when an occupant is removed.
 *
 * This should be where physicality-agnostic hooks are made, like removing custom actions / handling
 *
 * @params
 * * removing - the mob
 * * actor - the person removing the mob, usually the mob themselves
 * * control_flags - the old control flags of the mob
 * * silent - suppress messages to user
 * * suppressed - suppress visible messages to others
 */
/obj/vehicle/proc/occupant_added(mob/adding, datum/event_args/actor/actor, control_flags, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)
	// todo: this shoudln't be here
	auto_assign_occupant_flags(adding)

/**
 * Call to remove a mob from occupants
 *
 * * this should usually be internally called by the specific abstraction of vehicles underneath our path
 */
/obj/vehicle/proc/remove_occupant(mob/removing)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!istype(removing))
		return FALSE
	remove_control_flags(removing, ALL)
	remove_passenger_actions(removing)
	var/old_flags = occupants[removing]
	occupants -= removing
	cleanup_actions_for_mob(removing)
	// remove only ones without flags; remove_control_flags() handles the ones with
	for(var/datum/action/vehicle/action as anything in occupant_actions)
		if(action.required_control_flags)
			continue
		action.revoke(removing.actions_controlled)
	// call removed hook
	occupant_removed(removing, new /datum/event_args/actor(removing), old_flags, FALSE)
	return TRUE

/**
 * Called when an occupant is removed.
 *
 * This should be where physicality-agnostic hooks are made, like removing custom actions / handling
 *
 * @params
 * * removing - the mob
 * * actor - the person removing the mob, usually the mob themselves
 * * control_flags - the old control flags of the mob
 * * silent - suppress messages to user
 * * suppressed - suppress visible messages to others
 */
/obj/vehicle/proc/occupant_removed(mob/removing, datum/event_args/actor/actor, control_flags, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)
