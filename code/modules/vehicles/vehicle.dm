//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/armor/vehicle

TYPE_REGISTER_SPATIAL_GRID(/obj/vehicle, SSspatial_grids.vehicles)
/**
 * generic, multiseat-capable vehicles system
 *
 * ## Concepts
 * * The 'chassis' is ourselves. Chassis armor / integrity are handled via atom integrity.
 *   This may change in the future, so use wrappers in `vehicle-defense.dm`
 */
/obj/vehicle
	integrity = 300
	integrity_max = 300
	integrity_failure = 0
	armor_type = /datum/armor/vehicle

	//* Cargo Hold *//
	/// Things in cargo hold
	/// * Lazy list
	/// * Should technically be a module but for better or worse this is an intrinsic of the /mecha
	///   type. This allows all mechs to use hydraulic clamps to pick up cargo.
	var/list/atom/movable/cargo_held
	/// Cargo hold capacity
	var/cargo_capacity = 1

	//* Components *//
	/// Installed components
	/// * Lazy list.
	var/list/obj/item/vehicle_component/components

	//* Modules *//
	/// Modules. Set to typepath list to init.
	/// * Lazy list.
	var/list/obj/item/vehicle_module/modules
	/// Modules that should not be removable. They will be rendered unable to be destroyed
	/// and also unable to be removed.
	/// * Nulled after init
	/// * Lazy list.
	/// * These will never be salvageable off the loot.
	/// * These won't count towards slot limits and class limits.
	var/list/modules_intrinsic
	#warn handle this shit
	/// Module slot limits
	/// * VEHICLE_MODULE_SLOT_* associated to a number.
	var/list/module_slots = list()
	/// Module classes to allow
	var/module_classes_allowed = ~(VEHICLE_MODULE_CLASS_MACRO | VEHICLE_MODULE_CLASS_MICRO)
	/// Active click module
	/// * Someday this'll be changed to actor HUD system so multiple people can select different ones.
	var/obj/item/module_active_click

	//* Movement *//
	/// Next move time
	var/move_delay = 0
	/// Base movement speed, in tile/seconds
	var/base_movement_speed = 5

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
	/// Are we in gravity right now? Used for movespeed.
	var/in_gravity = TRUE
	/// Last time we moved ourselves.
	var/last_self_move

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

	//* Repairs *//
	/// Repair droid efficiency
	var/repair_droid_inbound_efficiency = 1.0
	/// Repair droid max ratio to heal. Repair droids won't heal us above this of our max integrity minus failure integrity.
	/// * This includes `integrity_failure`!
	var/repair_droid_max_ratio = 1
	/// Additional repair droid efficiency, as multiplier, if already broken.
	var/repair_droid_recovery_efficiency = 2.5

	//* UI *//
	/// UI controller
	#warn hook this during merging
	var/datum/vehicle_ui_controller/ui_controller = /datum/vehicle_ui_controller

	//* Weight *//
	var/cached_component_weight = 0
	var/cached_module_weight = 0
	var/cached_cargo_weight = 0
	var/cached_occupant_weight = 0

/obj/vehicle/Initialize(mapload)
	. = ..()
	create_initial_components()
	update_gravity()

/obj/vehicle/Destroy()
	QDEL_LAZYLIST(components)
	QDEL_LAZYLIST(modules)
	QDEL_NULL(ui_controller)
	QDEL_LIST_NULL(occupant_actions)
	return ..()

/obj/vehicle/examine(mob/user, dist)
	. = ..()
	var/datum/event_args/examine/examine = new(user)
	. += examine_render_components(examine)
	for(var/obj/item/vehicle_module/module as anything in modules)
		. += "It has a [icon2html(module, world)] [module] installed."

/obj/vehicle/drop_products(method, atom/where)
	..()
	drop_vehicle_contents(where)

/**
 * Called to drop everything in vehicle.
 */
/obj/vehicle/proc/drop_vehicle_contents(atom/where)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	on_drop_vehicle_contents(where || drop_location())

/**
 * Drop vehicle stuff here.
 */
/obj/vehicle/proc/on_drop_vehicle_contents(atom/where)
	return

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

//* Cargo *//

/obj/vehicle/proc/cargo_add(atom/movable/entity)
	if(entity in cargo_held)
		return
	cargo_held += entity
	entity.forceMove(src)
	on_cargo_add(entity)

/obj/vehicle/proc/cargo_slots_used()
	return length(cargo_held)

/obj/vehicle/proc/cargo_slots_capacity()
	return cargo_capacity

/obj/vehicle/proc/cargo_slots_remaining()
	return cargo_capacity - length(cargo_held)

/obj/vehicle/proc/cargo_dump(atom/where = drop_location())
	if(!where)
		return 0
	. = 0
	for(var/atom/movable/entity in cargo_held)
		entity.forceMove(where)
		.++

/obj/vehicle/proc/on_cargo_add(atom/movable/entity)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/vehicle/proc/on_cargo_remove(atom/movable/entity)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/vehicle/Exited(atom/movable/AM, atom/newLoc)
	..()
	if(AM in cargo_held)
		cargo_held -= AM
		on_cargo_remove(AM)

//* HUDs *//

// todo: clear_occupant_huds()
// todo: add_occupant_hud(datum/atom_hud/hud_like)
// todo: remove_occupant_hud(datum/atom_hud/hud_like)
// todo: resolve_occupant_huds() - make sure list is instances, not ids; needed to dedupe and resolve for add/remove

//* Logging *//

/**
 * * Anything fed in here is sent to game logs.
 * * Includes ckeys.
 */
/obj/vehicle/proc/vehicle_log_for_admins(datum/event_args/actor/actor, action, list/params)
	log_game("VEHICLE: [src] ([ref(src)]) ([type]) - [actor.actor_log_string()]: [action][params ? " - [json_encode(params)]" : ""]")

/**
 * * Eventually used to allow things like mechs to maintain internal logs.
 * * Anything fed in here is IC. Don't leak ckeys.
 */
/obj/vehicle/proc/vehicle_log_for_fluff_ic()
	CRASH("not implemented")

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

//* Weight Handling *//

/obj/vehicle/on_contents_weight_change(atom/movable/entity, old_weight, new_weight)
	..()
	if(istype(entity, /obj/item/vehicle_component) && (entity in components))
		cached_component_weight += (new_weight - old_weight)
	if(istype(entity, /obj/item/vehicle_module) && (entity in modules))
		cached_module_weight += (new_weight - old_weight)

	// TODO: /atom/movable level weight
	// if(entity in occupants)
	// if(entity in cargo_held)

	ui_controller?.queue_update_weight_data()

/obj/vehicle/retally_containing_weight()
	..()
	cached_component_weight = 0
	cached_module_weight = 0
	cached_cargo_weight = 0
	cached_occupant_weight = 0

	// TODO: /atom/movable level weight
	// for(var/mob/rider as anything in occupants)
	// for(var/atom/movable/entity as anything in cargo_held)

	for(var/obj/item/vehicle_component/comp as anything in components)
		cached_component_weight += comp.get_weight()

	for(var/obj/item/vehicle_module/mod as anything in modules)
		cached_module_weight += mod.get_weight()

	ui_controller?.queue_update_weight_data()
