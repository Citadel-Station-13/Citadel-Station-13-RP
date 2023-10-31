/obj/machinery/turnstile
	name = "turnstile"
	desc = "A mechanical door that permits one-way access and prevents tailgating."
	icon = 'icons/obj/turnstile.dmi'
	icon_state = "turnstile_map"
	power_channel = POWER_CHANNEL_ENVIR
	density = FALSE
	anchored = TRUE
	use_power = FALSE
	idle_power_usage = 2
	layer = DOOR_OPEN_LAYER

/obj/machinery/turnstile/Initialize()
	. = ..()
	icon_state = "turnstile"

/obj/machinery/turnstile/CanAtmosPass(turf/T)
	return TRUE

/*
/obj/machinery/turnstile/bullet_act(obj/item/projectile/P, def_zone)
	return -1 //Pass through!
*/

/obj/machinery/turnstile/proc/allowed_access(var/mob/B)
	if(B.pulledby && ismob(B.pulledby))
		return allowed(B.pulledby) | allowed(B)
	else
		return allowed(B)

/obj/machinery/turnstile/CanPass(atom/movable/AM, turf/T)
	if(ismob(AM))
		var/mob/B = AM
		if(isliving(AM))
			var/mob/living/M = AM

			if(world.time - M.last_bumped <= 5)
				return FALSE
			M.last_bumped = world.time

			var/allowed_access = FALSE
			var/turf/behind = get_step(src, dir)

			if(B in behind.contents)
				allowed_access = allowed_access(B)
			else
				to_chat(usr, "<span class='notice'>\the [src] resists your efforts.</span>")
				flick("deny", src)
				playsound(src,'sound/machines/deniedbeep.ogg',50,0,3)
				return FALSE

			if(allowed_access)
				flick("operate", src)
				playsound(src,'sound/items/ratchet.ogg',50,0,3)
				return TRUE
			else
				flick("deny", src)
				playsound(src,'sound/machines/deniedbeep.ogg',50,0,3)
				return FALSE
	if(ispath(AM, /obj/item/))
		return TRUE
	else
		return FALSE

/obj/machinery/turnstile/CheckExit(atom/movable/AM as mob|obj, target)
	if(isliving(AM))
		var/mob/living/M = AM
		var/outdir = dir
		if(allowed_access(M))
			switch(dir)
				if(NORTH)
					outdir = SOUTH
				if(SOUTH)
					outdir = NORTH
				if(EAST)
					outdir = WEST
				if(WEST)
					outdir = EAST
		var/turf/outturf = get_step(src, outdir)
		var/canexit = (target == src.loc) | (target == outturf)

		if(!canexit && world.time - M.last_bumped <= 5)
			to_chat(usr, "<span class='notice'>\the [src] resists your efforts.</span>")
		M.last_bumped = world.time
		return canexit
	else
		return TRUE

/obj/machinery/turnstile/entry
	name = "\improper Entrance"
	req_one_access = 111

/obj/machinery/turnstile/exit
	name = "\improper Exit"
	req_one_access = 112
