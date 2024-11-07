TYPE_REGISTER_SPATIAL_GRID(/obj/vehicle, SSspatial_grids.vehicles)
/**
 * generic, multiseat-capable vehicles system
 *
 * ! Port of old vehicles underway. Maintain typepath if possible.
 */
/obj/vehicle
	name = "generic vehicle"
	desc = "Yell at coderbus."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "fuckyou"
	// integrity_max = 300
	// armor = list(MELEE = 30, BULLET = 30, LASER = 30, ENERGY = 0, BOMB = 30, BIO = 0, RAD = 0, FIRE = 60, ACID = 60)
	density = TRUE
	anchored = FALSE
	buckle_flags = BUCKLING_PASS_PROJECTILES_UPWARDS
	COOLDOWN_DECLARE(cooldown_vehicle_move)

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

	var/max_occupants = 1
	var/max_drivers = 1
	var/movedelay = 2
	var/lastmove = 0
	var/key_type
	var/obj/item/key/inserted_key
	var/key_type_exact = TRUE		//can subtypes work
	var/canmove = TRUE
	// todo: emulate_door_bumps is shitcode please change it
	var/emulate_door_bumps = TRUE	//when bumping a door try to make occupants bump them to open them.
	var/default_driver_move = TRUE	//handle driver movement instead of letting something else do it like riding datums.
	var/enclosed = FALSE	// is the rider protected from bullets? assume no
	var/list/autogrant_actions_passenger	//plain list of typepaths
	var/list/autogrant_actions_controller	//assoc list "[bitflag]" = list(typepaths)
	var/list/mob/occupant_actions_legacy			//assoc list mob = list(type = action datum assigned to mob)
	var/obj/vehicle/trailer
	var/mouse_pointer //do we have a special mouse

/obj/vehicle/Initialize(mapload)
	. = ..()
	initialize_occupant_actions()
	occupants = list()
	autogrant_actions_passenger = list()
	autogrant_actions_controller = list()
	occupant_actions_legacy = list()
	generate_actions()

/obj/vehicle/Destroy()
	// remove all occupants if any are left
	if(length(occupants))
		stack_trace("still had occupants on Destroy. how?")
		for(var/mob/occupant in occupants)
			remove_occupant(occupant)
	// null out hud providers
	occupant_huds = null // null them out
	// delete our key
	QDEL_NULL(inserted_key)
	// legacy: get rid of trailer
	trailer = null
	// get rid of occupant actions
	QDEL_LIST_NULL(occupant_actions)
	return ..()

/obj/vehicle/examine(mob/user, dist)
	. = ..()
	/*
	if(resistance_flags & ON_FIRE)
		. += "<span class='warning'>It's on fire!</span>"
	var/healthpercent = obj_integrity/integrity_max * 100
	switch(healthpercent)
		if(50 to 99)
			. += "It looks slightly damaged."
		if(25 to 50)
			. += "It appears heavily damaged."
		if(0 to 25)
			. += "<span class='warning'>It's falling apart!</span>"
	*/

/obj/vehicle/proc/is_key(obj/item/I)
	return I? (key_type_exact? (I.type == key_type) : istype(I, key_type)) : FALSE

/obj/vehicle/proc/return_occupants()
	return occupants

/obj/vehicle/proc/occupant_amount()
	return length(occupants)

/obj/vehicle/proc/return_amount_of_controllers_with_flag(flag)
	. = 0
	for(var/i in occupants)
		if(occupants[i] & flag)
			.++

/obj/vehicle/proc/return_controllers_with_flag(flag)
	RETURN_TYPE(/list/mob)
	. = list()
	for(var/i in occupants)
		if(occupants[i] & flag)
			. += i

/obj/vehicle/proc/return_drivers()
	return return_controllers_with_flag(VEHICLE_CONTROL_DRIVE)

/obj/vehicle/proc/driver_amount()
	return return_amount_of_controllers_with_flag(VEHICLE_CONTROL_DRIVE)

/obj/vehicle/proc/is_driver(mob/M)
	return is_occupant(M) && occupants[M] & VEHICLE_CONTROL_DRIVE

/obj/vehicle/proc/auto_assign_occupant_flags(mob/M) //override for each type that needs it. Default is assign driver if drivers is not at max.
	if(driver_amount() < max_drivers)
		add_control_flags(M, VEHICLE_CONTROL_DRIVE | VEHICLE_CONTROL_USE_HUDS | VEHICLE_CONTROL_EXIT)

/obj/vehicle/relaymove(mob/user, direction)
	if(is_driver(user))
		return driver_move(user, direction)
	return FALSE

/obj/vehicle/proc/driver_move(mob/user, direction)
	if(key_type && !is_key(inserted_key))
		to_chat(user, "<span class='warning'>[src] has no key inserted!</span>")
		return FALSE
	if(!default_driver_move)
		return
	vehicle_move(direction)

/obj/vehicle/proc/vehicle_move(direction)
	if(!COOLDOWN_FINISHED(src, cooldown_vehicle_move))
		return FALSE
	COOLDOWN_START(src, cooldown_vehicle_move, movedelay)
	if(trailer)
		var/dir_to_move = get_dir(trailer.loc, loc)
		var/did_move = step(src, direction)
		if(did_move)
			step(trailer, dir_to_move)
		return did_move
	else
		after_move(direction)
		return step(src, direction)

/obj/vehicle/proc/after_move(direction)
	return

/obj/vehicle/Bump(atom/movable/M)
	. = ..()
	if(emulate_door_bumps)
		if(istype(M, /obj/machinery/door))
			for(var/m in occupants)
				M.Bumped(m)

/obj/vehicle/Move(newloc, dir)
	. = ..()
	if(trailer && .)
		var/dir_to_move = get_dir(trailer.loc, newloc)
		step(trailer, dir_to_move)

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
