// TG stuff in here
// Do not move to vehicle.dm with the new copyright and code.
// Most of these should be refactored away; this includes most code for autogrant-actions.

/obj/vehicle
	name = "generic vehicle"
	desc = "Yell at coderbus."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "fuckyou"
	density = TRUE
	anchored = FALSE
	buckle_flags = BUCKLING_PASS_PROJECTILES_UPWARDS

	var/max_occupants = 1
	var/max_drivers = 1
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
