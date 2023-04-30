/obj/structure/plasticflaps //HOW DO YOU CALL THOSE THINGS ANYWAY
	name = "\improper plastic flaps"
	desc = "Completely impassable - or are they?"
	icon = 'icons/obj/stationobjs.dmi' //Change this.
	icon_state = "plasticflaps"
	density = 0
	anchored = 1
	pass_flags = NONE
	layer = MOB_LAYER
	plane = MOB_PLANE
	explosion_resistance = 5
	var/can_pass_lying = TRUE
	var/list/mobs_can_pass = list(
		/mob/living/bot,
		/mob/living/simple_mob/slime/xenobio,
		/mob/living/simple_mob/animal/passive/mouse,
		/mob/living/silicon/robot/drone
		)

/obj/structure/plasticflaps/Initialize(mapload)
	. = ..()
	AIR_UPDATE_ON_INITIALIZE_AUTO

/obj/structure/plasticflaps/Destroy()
	AIR_UPDATE_ON_DESTROY_AUTO
	return ..()

/obj/structure/plasticflaps/Moved(atom/oldloc)
	. = ..()
	AIR_UPDATE_ON_MOVED_AUTO

/obj/structure/plasticflaps/attackby(obj/item/P, mob/user)
	if(P.is_wirecutter())
		playsound(src, P.tool_sound, 50, 1)
		to_chat(user, "<span class='notice'>You start to cut the plastic flaps.</span>")
		if(do_after(user, 10 * P.tool_speed))
			to_chat(user, "<span class='notice'>You cut the plastic flaps.</span>")
			var/obj/item/stack/material/plastic/A = new /obj/item/stack/material/plastic( src.loc )
			A.amount = 4
			qdel(src)
		return
	else
		return

/obj/structure/plasticflaps/CanAStarPass(obj/item/card/id/ID, to_dir, atom/movable/caller)
	if(isliving(caller))
		if(isbot(caller))
			return TRUE

		var/mob/living/living_caller = caller
		if(!living_caller.can_ventcrawl() && living_caller.mob_size > MOB_TINY)
			return FALSE

	if(caller?.pulling)
		return CanAStarPass(ID, to_dir, caller.pulling)
	return TRUE //diseases, stings, etc can pass

/obj/structure/plasticflaps/CanAllowThrough(atom/movable/mover, turf/target)
	if(mover.check_pass_flags(ATOM_PASS_GLASS) && prob(60))
		return TRUE

	var/obj/structure/bed/B = mover
	if (istype(mover, /obj/structure/bed) && B.has_buckled_mobs())//if it's a bed/chair and someone is buckled, it will not pass
		return 0

	if(isvehicle(mover))
		return FALSE

	var/mob/living/M = mover
	if(istype(M))
		if(M.lying && can_pass_lying)
			return ..()
		for(var/mob_type in mobs_can_pass)
			if(istype(mover, mob_type))
				return ..()
		return issmall(M)

	return ..()

/obj/structure/plasticflaps/legacy_ex_act(severity)
	switch(severity)
		if (1)
			qdel(src)
		if (2)
			if (prob(50))
				qdel(src)
		if (3)
			if (prob(5))
				qdel(src)

/obj/structure/plasticflaps/mining //A specific type for mining that doesn't allow airflow because of them damn crates
	name = "airtight plastic flaps"
	desc = "Heavy duty, airtight, plastic flaps. Have extra safety installed, preventing passage of living beings."
	CanAtmosPass = ATMOS_PASS_AIR_BLOCKED
