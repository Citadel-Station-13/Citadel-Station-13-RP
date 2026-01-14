/obj/item/vehicle_module/lazy/legacy/tool/passenger
	name = "passenger compartment"
	desc = "A mountable passenger compartment for exosuits. Rather cramped."
	icon_state = "mecha_passenger"
	origin_tech = list(TECH_ENGINEERING = 1, TECH_BIO = 1)
	energy_drain = 10
	range = MELEE
	equip_cooldown = 20
	var/mob/living/carbon/occupant_legacy = null
	var/door_locked = TRUE

/obj/item/vehicle_module/lazy/legacy/tool/passenger/destroy()
	for(var/atom/movable/AM in src)
		AM.forceMove(get_turf(src))
		to_chat(AM, "<span class='danger'>You tumble out of the destroyed [src.name]!</span>")
	return ..()

/obj/item/vehicle_module/lazy/legacy/tool/passenger/Exit(atom/movable/O)
	return 0

/obj/item/vehicle_module/lazy/legacy/tool/passenger/proc/move_inside(var/mob/user)
	if (chassis)
		chassis.visible_message("<span class='notice'>[user] starts to climb into [chassis].</span>")

	if(do_after(user, 40, chassis, DO_AFTER_IGNORE_ACTIVE_ITEM))
		if(!src.occupant_legacy)
			//? WARNING WARNING SHITCODE ALERT
			//? BYOND WILL REFUSE TO PROPERLY UPDATE STUFF IF WE MOVE IN IMMEDIATELY
			//? THUS, SLEEP A SINGLE TICK.
			spawn(world.tick_lag)
				user.forceMove(src)
				user.update_perspective()
			add_verb(user, /mob/proc/verb_eject_mech_passenger)
			occupant_legacy = user
			occupant_message("[user] boarded.")
		else if(src.occupant_legacy != user)
			to_chat(user, "<span class='warning'>[src.occupant_legacy] was faster. Try harder next time, loser.</span>")
	else
		to_chat(user, "You stop entering the exosuit.")

// todo: action
/mob/proc/verb_eject_mech_passenger()
	set name = "Eject Passenger"
	set category = "Exosuit Interface"
	set src = usr

	var/obj/item/vehicle_module/lazy/legacy/tool/passenger/pod = loc
	if(!istype(pod))
		remove_verb(src, /mob/proc/verb_eject_mech_passenger)
		return
	if(src != pod.occupant_legacy)
		forceMove(get_turf(pod))
		remove_verb(src, /mob/proc/verb_eject_mech_passenger)
		return
	to_chat(src, "You climb out from \the [src].")
	pod.go_out()
	pod.occupant_message("[pod.occupant_legacy] disembarked.")
	pod.add_fingerprint(src)

/obj/item/vehicle_module/lazy/legacy/tool/passenger/proc/go_out()
	if(!occupant_legacy)
		return
	remove_verb(occupant_legacy, /mob/proc/verb_eject_mech_passenger)
	occupant_legacy.forceMove(get_turf(src))
	occupant_legacy.update_perspective()
	occupant_legacy = null
	return

/obj/item/vehicle_module/lazy/legacy/tool/passenger/on_install(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	..()
	add_obj_verb(vehicle, /obj/vehicle/sealed/mecha/proc/move_inside_passenger)

/obj/item/vehicle_module/lazy/legacy/tool/passenger/on_uninstall(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	go_out()
	..()
	if(!(locate(/obj/item/vehicle_module/lazy/legacy/tool/passenger) in vehicle.modules))
		remove_verb(vehicle, /obj/vehicle/sealed/mecha/proc/move_inside_passenger)

/obj/item/vehicle_module/lazy/legacy/tool/passenger/render_ui()
	..()
	l_ui_select("lock", "Hatch Lock", list("Locked", "Unlocked"), door_locked ? "Locked" : "Unlocked")

/obj/item/vehicle_module/lazy/legacy/tool/passenger/on_l_ui_select(datum/event_args/actor/actor, key, name)
	. = ..()
	if(.)
		return
	switch(key)
		if("lock")
			switch(name)
				if("Locked")
					if(door_locked)
						return TRUE
					door_locked = TRUE
					#warn log
					#warn chassis / occupant message?
					return TRUE
				if("Unlocked")
					if(!door_locked)
						return TRUE
					door_locked = FALSE
					#warn log
					#warn chassis / occupant message?
					return TRUE

// TODO: nuke this stupid fucking verb / proc and make it a managed action / context menu thing.
#define LOCKED 1
#define OCCUPIED 2

/obj/vehicle/sealed/mecha/proc/move_inside_passenger()
	set category = VERB_CATEGORY_OBJECT
	set name = "Enter Passenger Compartment"
	set src in oview(1)

	//check that usr can climb in
	if (usr.stat || !ishuman(usr))
		return

	if (!usr.Adjacent(src))
		return

	if (!isturf(usr.loc))
		to_chat(usr, "<span class='danger'>You can't reach the passenger compartment from here.</span>")
		return

	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(C.handcuffed)
			to_chat(usr, "<span class='danger'>Kinda hard to climb in while handcuffed don't you think?</span>")
			return

	if(isliving(usr))
		var/mob/living/L = usr
		if(L.has_buckled_mobs())
			to_chat(L, SPAN_WARNING( "You have other entities attached to yourself. Remove them first."))
			return

	//search for a valid passenger compartment
	var/feedback = 0 //for nicer user feedback
	for(var/obj/item/vehicle_module/lazy/legacy/tool/passenger/P in src)
		var/didnt_pass = FALSE
		if (P.occupant_legacy)
			feedback |= OCCUPIED
			didnt_pass = TRUE
		if (P.door_locked)
			feedback |= LOCKED
			didnt_pass = TRUE
		if(didnt_pass)
			continue

		//found a boardable compartment
		P.move_inside(usr)
		return

	//didn't find anything
	switch (feedback)
		if (OCCUPIED)
			to_chat(usr, "<span class='danger'>The passenger compartment is already occupied!</span>")
		if (LOCKED)
			to_chat(usr, "<span class='warning'>The passenger compartment hatch is locked!</span>")
		if (OCCUPIED|LOCKED)
			to_chat(usr, "<span class='danger'>All of the passenger compartments are already occupied or locked!</span>")
		if (0)
			to_chat(usr, "<span class='warning'>\The [src] doesn't have a passenger compartment.</span>")

#undef LOCKED
#undef OCCUPIED
