/**
 * Vehicles where ocucpants are inside / in contents, rather than buckled
 */
/obj/vehicle/sealed
	enclosed = TRUE // you're in a sealed vehicle dont get dinked idiot

	//* Occupants - Actions *//
	occupant_actions = list(
		/datum/action/vehicle/sealed/climb_out,
	)

	var/enter_delay = 20

/obj/vehicle/sealed/MouseDroppedOn(atom/dropping, mob/user, proximity, params)
	if(!istype(dropping) || !isliving(user) || !user.Reachability(src) || !Adjacent(dropping))
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
	return ..()

/obj/vehicle/sealed/proc/DumpMobs(randomstep = TRUE)
	for(var/i in occupants)
		mob_exit(i)
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
 * * silent - suppress user messages
 * * suppressed - suppress external messages
 * * enter_delay - the delay for the entry (they have to stay still relative to us)
 * * use_control_flags - override the normal control flags and use these instead
 */
/obj/vehicle/sealed/proc/mob_try_enter(mob/entering, datum/event_args/actor/actor, silent, suppressed, enter_delay = src.enter_delay, use_control_flags)
	if(isnull(actor))
		actor = new /datum/event_args/actor(entering)
	if(!mob_can_enter(entering, actor, silent, suppressed))
		return FALSE
	if(enter_delay && !suppressed)
		entering.visible_message(SPAN_NOTICE("[entering] starts to climb into [src]."))
	if(do_after(entering, enter_delay, src, NONE, MOBILITY_CAN_USE))
		return mob_enter(entering)
	return FALSE

/**
 * checks if a mob can enter
 */
/obj/vehicle/sealed/proc/mob_can_enter(mob/entering, datum/event_args/actor/actor, silent, suppressed)
	if(!istype(entering))
		return FALSE
	if(occupant_amount() >= max_occupants)
		return FALSE
	return TRUE

/**
 * Called to put someone into us.
 *
 * This should not be overridden; use [mob_entered()] for that
 *
 * @params
 * * entering - the person attempting to enter
 * * actor - the person trying to put them in us; usually the same as entering, but not always
 * * silent - suppress user messages
 * * suppressed - suppress external messages
 * * use_control_flags - override the normal control flags and use these instead
 */
/obj/vehicle/sealed/proc/mob_enter(mob/entering, datum/event_args/actor/actor, silent, suppressed, use_control_flags)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!silent)
		entering.visible_message("<span class='notice'>[entering] climbs into \the [src]!</span>")
	entering.forceMove(src)
	entering.update_perspective()
	// todo: update
	add_occupant(entering, control_flags = use_control_flags)
	mob_entered(entering, entering, silent, suppressed, occupants[entering])
	return TRUE

/**
 * At this point, the entry has already happened.
 *
 * * Use this for physicality hooks, so refactoring later is easy.
 *
 * @params
 * * entering - the person who entered
 * * actor - the person who put them in us; usually the same as the entering mob, but not always
 * * silent - suppress user messages
 * * suppressed - suppress external messages
 * * control_flags - control flags given to them
 */
/obj/vehicle/sealed/proc/mob_entered(mob/entering, datum/event_args/actor/actor, silent, suppressed, control_flags)
	return

/**
 * Called when someone tries to eject from us
 *
 * @params
 * * exiting - the person attempting to exit
 * * actor - the person trying to eject them; usually the same as exiting, but not always
 * * new_loc - where to put them after
 * * silent - suppress user messages
 * * suppressed - suppress external messages
 */
/obj/vehicle/sealed/proc/mob_try_exit(mob/exiting, datum/event_args/actor/actor, atom/new_loc = drop_location(), silent, suppressed)
	if(!mob_can_exit(exiting, actor, silent, suppressed))
		return FALSE
	return mob_exit(exiting, actor, new_loc, silent, suppressed)

/**
 * checks if a mob can exit
 */
/obj/vehicle/sealed/proc/mob_can_exit(mob/entering, datum/event_args/actor/actor, silent, suppressed)
	return TRUE

/**
 * Called to eject someone from us
 *
 * This cannot be overridden
 *
 * @params
 * * exiting - the person attempting to exit
 * * actor - the person trying to eject them; usually the same as exiting, but not always
 * * new_loc - where to put them after
 * * silent - suppress user messages
 * * suppressed - suppress external messages
 */
/obj/vehicle/sealed/proc/mob_exit(mob/exiting, datum/event_args/actor/actor, atom/new_loc = drop_location(), silent, suppressed)
	var/old_control_flags = occupants[exiting]
	remove_occupant(exiting)
	exiting.forceMove(new_loc)
	exiting.update_perspective()
	mob_exited(exiting, actor, silent, suppressed, old_control_flags)
	if(!silent)
		exiting.visible_message("<span class='notice'>[exiting] drops out of \the [src]!</span>")
	return TRUE

/**
 * At this point, the exit has already happened.
 *
 * * Use this for physicality hooks, so refactoring later is easy.
 *
 * @params
 * * exiting - the person who exited
 * * actor - the person who took them out of us; usually the same as the exiting mob, but not always
 * * silent - suppress user messages
 * * suppressed - suppress external messages
 * * control_flags - control flags they had before exit
 */
/obj/vehicle/sealed/proc/mob_exited(mob/exiting, datum/event_args/actor/actor, silent, suppressed, control_flags)
	return
