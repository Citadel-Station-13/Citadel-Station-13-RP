/**
 * Vehicles where ocucpants are inside / in contents, rather than buckled
 */
/obj/vehicle/sealed
	enclosed = TRUE // you're in a sealed vehicle dont get dinked idiot
	var/enter_delay = 20
	var/explode_on_death = TRUE
	
/obj/vehicle/sealed/generate_actions()
	. = ..()
	initialize_passenger_action_type(/datum/action/vehicle/sealed/climb_out)

/obj/vehicle/sealed/MouseDroppedOn(atom/dropping, mob/user, proximity, params)
	if(!istype(dropping) || !isliving(user))
		return ..()
	if(user == dropping)
		mob_try_enter(user)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/vehicle/sealed/attackby(obj/item/I, mob/user, params)
	if(key_type && !is_key(inserted_key) && is_key(I))
		. = CLICKCHAIN_DO_NOT_PROPAGATE
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		to_chat(user, "<span class='notice'>You insert [I] into [src].</span>")
		if(inserted_key)	//just in case there's an invalid key
			inserted_key.forceMove(drop_location())
		inserted_key = I
		return
	return ..()

/obj/vehicle/sealed/proc/remove_key(mob/user)
	if(!inserted_key)
		to_chat(user, "<span class='notice'>There is no key in [src]!</span>")
		return
	if(!is_occupant(user) || !(occupants[user] & VEHICLE_CONTROL_DRIVE))
		to_chat(user, "<span class='notice'>You must be driving [src] to remove [src]'s key!</span>")
		return
	to_chat(user, "<span class='notice'>You remove [inserted_key] from [src].</span>")
	inserted_key.forceMove(drop_location())
	user.put_in_hands(inserted_key)
	inserted_key = null

/obj/vehicle/sealed/Destroy()
	DumpMobs()
	if(explode_on_death)
		explosion(loc, 0, 1, 2, 3, 0)
	return ..()

/obj/vehicle/sealed/proc/DumpMobs(randomstep = TRUE)
	for(var/i in occupants)
		mob_exit(i, null, randomstep)
		if(iscarbon(i))
			var/mob/living/carbon/Carbon = i
			Carbon.default_combat_knockdown(40)

/obj/vehicle/sealed/proc/DumpSpecificMobs(flag, randomstep = TRUE)
	for(var/i in occupants)
		if((occupants[i] & flag))
			mob_exit(i, null, randomstep)
			if(iscarbon(i))
				var/mob/living/carbon/C = i
				C.default_combat_knockdown(40)

/obj/vehicle/sealed/AllowDrop()
	return FALSE

/obj/vehicle/sealed/setDir(newdir)
	. = ..()
	for(var/k in occupants)
		var/mob/M = k
		M.setDir(newdir)

//* Entry / Exit *//

/**
 * Called when someone tries to climb into us.
 * 
 * @params
 * * entering - the person attempting to enter
 * * actor - the person trying to put them in us; usually the same as entering, but not always
 * * silent - suppress external messages
 * * enter_delay - the delay for the entry (they have to stay still relative to us)
 * * use_control_flags - override the normal control flags and use these instead
 */
/obj/vehicle/sealed/proc/mob_try_enter(mob/entering, datum/event_args/actor/actor, silent, enter_delay = enter_delay, use_control_flags)
	if(isnull(actor))
		actor = new /datum/event_args/actor(entering)
	if(!istype(entering))
		return FALSE
	if(occupant_amount() >= max_occupants)
		return FALSE
	if(do_after(entering, get_enter_delay(M), src, FALSE, TRUE))
		mob_enter(entering)
		return TRUE
	return FALSE

/**
 * Called to put someone into us.
 * 
 * This should not be overridden; use [mob_entered()] for that
 * 
 * @params
 * * entering - the person attempting to enter
 * * actor - the person trying to put them in us; usually the same as entering, but not always
 * * silent - suppress external messages
 * * use_control_flags - override the normal control flags and use these instead
 */
/obj/vehicle/sealed/proc/mob_enter(mob/entering, datum/event_args/actor/actor, silent, use_control_flags)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!istype(entering))
		return FALSE
	if(!silent)
		entering.visible_message("<span class='notice'>[entering] climbs into \the [src]!</span>")
	entering.forceMove(src)
	add_occupant(entering)
	#warn change
	mob_entered(entering, uesr, silent, occupants[entering])
	return TRUE

/**
 * At this point, the entry has already happened.
 * 
 * @params
 * * entering - the person who entered
 * * actor - the person who put them in us; usually the same as entering, but not always
 * * silent - suppress external messages
 * * control_flags - override the normal control flags and use these instead
 */
/obj/vehicle/sealed/proc/mob_entered(mob/entering, datum/event_args/actor/actor, silent, control_flags)
	return

#warn below

/**
 * Called when someone attempts to eject from us
 */
/obj/vehicle/sealed/proc/mob_try_exit(mob/exiting, datum/event_args/actor/actor, atom/new_loc = drop_location(), silent)
	mob_exit(exiting, silent, randomstep)

/obj/vehicle/sealed/proc/mob_exit(mob/exiting, datum/event_args/actor/actor, atom/new_loc, silent)
	SIGNAL_HANDLER
	if(!istype(exiting))
		return FALSE
	remove_occupant(exiting)
	if(!isAI(exiting))//This is the ONE mob we dont want to be moved to the vehicle that should be handeled when used
		exiting.forceMove(exit_location(exiting))
	if(randomstep)
		var/turf/target_turf = get_step(exit_location(exiting), pick(GLOB.cardinal))
		exiting.throw_at(target_turf, 5, 10)

	if(!silent)
		exiting.visible_message("<span class='notice'>[exiting] drops out of \the [src]!</span>")
	return TRUE

/**
 * at this point, they have already exited
 */
/obj/vehicle/sealed/proc/mob_exited(mob/exiting, datum/event_args/actor/actor, silent, control_flags)
	return
