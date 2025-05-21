/obj/item/vehicle_module/tool/passenger
	name = "passenger compartment"
	desc = "A mountable passenger compartment for exosuits. Rather cramped."
	icon_state = "mecha_passenger"
	origin_tech = list(TECH_ENGINEERING = 1, TECH_BIO = 1)
	energy_drain = 10
	range = MELEE
	equip_cooldown = 20
	var/mob/living/carbon/occupant_legacy = null
	var/door_locked = 1
	salvageable = 0
	allow_duplicate = TRUE

	equip_type = EQUIP_HULL

/obj/item/vehicle_module/tool/passenger/destroy()
	for(var/atom/movable/AM in src)
		AM.forceMove(get_turf(src))
		to_chat(AM, "<span class='danger'>You tumble out of the destroyed [src.name]!</span>")
	return ..()

/obj/item/vehicle_module/tool/passenger/Exit(atom/movable/O)
	return 0

/obj/item/vehicle_module/tool/passenger/proc/move_inside(var/mob/user)
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
			log_message("[user] boarded.")
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

	var/obj/item/vehicle_module/tool/passenger/pod = loc
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
	pod.log_message("[pod.occupant_legacy] disembarked.")
	pod.add_fingerprint(src)

/obj/item/vehicle_module/tool/passenger/proc/go_out()
	if(!occupant_legacy)
		return
	remove_verb(occupant_legacy, /mob/proc/verb_eject_mech_passenger)
	occupant_legacy.forceMove(get_turf(src))
	occupant_legacy.update_perspective()
	occupant_legacy = null
	return

/obj/item/vehicle_module/tool/passenger/attach()
	..()
	if (chassis)
		add_obj_verb(chassis, /obj/vehicle/sealed/mecha/proc/move_inside_passenger)

/obj/item/vehicle_module/tool/passenger/detach()
	if(occupant_legacy)
		occupant_message("Unable to detach [src] - equipment occupied.")
		return

	var/obj/vehicle/sealed/mecha/M = chassis
	..()
	if (M && !(locate(/obj/item/vehicle_module/tool/passenger) in M))
		remove_verb(M, /obj/vehicle/sealed/mecha/proc/move_inside_passenger)

/obj/item/vehicle_module/tool/passenger/get_equip_info()
	return "[..()] <br />[occupant_legacy? "\[Occupant: [occupant_legacy]\]|" : ""]Exterior Hatch: <a href='?src=\ref[src];toggle_lock=1'>Toggle Lock</a>"

/obj/item/vehicle_module/tool/passenger/Topic(href,href_list)
	..()
	if (href_list["toggle_lock"])
		door_locked = !door_locked
		occupant_message("Passenger compartment hatch [door_locked? "locked" : "unlocked"].")
		if (chassis)
			chassis.visible_message("The hatch on \the [chassis] [door_locked? "locks" : "unlocks"].", "You hear something latching.")


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
	for(var/obj/item/vehicle_module/tool/passenger/P in src)
		if (P.occupant_legacy)
			feedback |= OCCUPIED
			continue
		if (P.door_locked)
			feedback |= LOCKED
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
