/obj/machinery/optable
	name = "the operating table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "table2-idle"
	pass_flags_self = ATOM_PASS_TABLE | ATOM_PASS_THROWN | ATOM_PASS_CLICK | ATOM_PASS_OVERHEAD_THROW
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/operating_table
	use_power = USE_POWER_IDLE
	idle_power_usage = 1
	active_power_usage = 5
	surgery_odds = 100
	var/mob/living/carbon/human/victim = null
	var/strapped = FALSE
	var/obj/machinery/computer/operating/computer = null

/obj/machinery/optable/Initialize(mapload)
	. = ..()
	default_apply_parts()

/obj/machinery/optable/Initialize(mapload)
	. = ..()
	for(var/direction in list(NORTH,EAST,SOUTH,WEST))
		computer = locate(/obj/machinery/computer/operating, get_step(src, direction))
		if(computer)
			computer.table = src
			break

//	spawn(100) //Wont the MC just call this process() before and at the 10 second mark anyway?
//		process()

/obj/machinery/optable/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				//SN src = null
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				density = 0

/obj/machinery/optable/attack_hand(mob/user)
	if(MUTATION_HULK in usr.mutations)
		visible_message(SPAN_DANGER("\The [usr] destroys \the [src]!"))
		density = FALSE
		qdel(src)

/obj/machinery/optable/proc/check_victim()
	if(locate(/mob/living/carbon/human, src.loc))
		var/mob/living/carbon/human/M = locate(/mob/living/carbon/human, src.loc)
		if(M.lying)
			victim = M
			icon_state = M.pulse ? "table2-active" : "table2-idle"
			return TRUE
	victim = null
	icon_state = "table2-idle"
	return FALSE

/obj/machinery/optable/process(delta_time)
	check_victim()

/obj/machinery/optable/proc/take_victim(mob/living/carbon/C, mob/living/carbon/user)
	if(C == user)
		user.visible_message("[user] climbs on \the [src].","You climb on \the [src].")
	else
		visible_message(SPAN_NOTICE("\The [C] has been laid on \the [src] by [user]."))
	C.resting = 1
	C.forceMove(loc)
	// now that we hold parts, this must be commented out to prevent dumping our parts onto our loc. not sure what this was intended to do when it was written.
	/*for(var/obj/O in src)
		O.loc = src.loc
	*/
	add_fingerprint(user)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		victim = H
		icon_state = H.pulse ? "table2-active" : "table2-idle"
	else
		icon_state = "table2-idle"

/obj/machinery/optable/MouseDroppedOnLegacy(mob/target, mob/user)

	var/mob/living/M = user
	if(user.stat || user.restrained() || !check_table(user) || !iscarbon(target))
		return
	if(istype(M))
		take_victim(target,user)
	else
		return ..()

/obj/machinery/optable/verb/climb_on()
	set name = "Climb On Table"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || !ishuman(usr) || usr.restrained() || !check_table(usr))
		return

	take_victim(usr,usr)

/obj/machinery/optable/attackby(obj/item/W, obj/item/I, mob/living/carbon/user)
	if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if(iscarbon(G.affecting) && check_table(G.affecting))
			take_victim(G.affecting,usr)
			qdel(W)
			return

/obj/machinery/optable/proc/check_table(mob/living/carbon/patient)
	check_victim()
	if(victim && get_turf(victim) == get_turf(src) && victim.lying)
		to_chat(usr, SPAN_WARNING("\The [src] is already occupied!"))
		return FALSE
	if(patient.buckled)
		to_chat(usr, SPAN_NOTICE("Unbuckle \the [patient] first!"))
		return FALSE
	return TRUE

/obj/machinery/sleeper/RefreshParts()
	var/cap_rating = 0

	idle_power_usage = initial(idle_power_usage)
	active_power_usage = initial(active_power_usage)

	for(var/obj/item/stock_parts/P in component_parts)
		if(istype(P, /obj/item/stock_parts/capacitor))
			cap_rating += P.rating

	cap_rating = max(1, round(cap_rating / 2))

	idle_power_usage /= cap_rating
	active_power_usage /= cap_rating
