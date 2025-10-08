
/*
Space dust
Commonish random event that causes small clumps of "space dust" to hit the station at high speeds.
The "dust" will damage the hull of the station causing minor hull breaches.
*/


/**
 * Spawns a random amount of space_dust thrown in random directions
 * dust_swarm(severity, list/affecting_z)
 *
 * severity - Takes a value from 1 to 4, defaults to 2.
 * affecting_z - Takes a list of z_levels to randomly target, defaults to main station levels.
 */
/proc/dust_swarm(var/severity = EVENT_LEVEL_MODERATE, var/list/affecting_z = (LEGACY_MAP_DATUM).station_levels.Copy())
	var/numbers = 1
	var/dust_type = /obj/effect/space_dust
	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			numbers = rand(2,4)
			dust_type = /obj/effect/space_dust/weak
		if(EVENT_LEVEL_MODERATE)
			numbers = rand(5,10)
			dust_type = /obj/effect/space_dust
		if(EVENT_LEVEL_MAJOR)
			numbers = rand(10,15)
			dust_type = /obj/effect/space_dust/strong
		if(EVENT_LEVEL_EXTREME)
			numbers = rand(15,25)
			dust_type = /obj/effect/space_dust/super

	var/startside = pick(GLOB.cardinal)
	for(var/i in 1 to numbers)
		var/startx = 0
		var/starty = 0
		var/endy = 0
		var/endx = 0
		switch(startside)
			if(NORTH)
				starty = world.maxy-TRANSITIONEDGE-1
				startx = rand(TRANSITIONEDGE+1, world.maxx-TRANSITIONEDGE-1)
				endy = TRANSITIONEDGE
				endx = rand(TRANSITIONEDGE+1, world.maxx-TRANSITIONEDGE-1)
			if(EAST)
				starty = rand(TRANSITIONEDGE+1, world.maxy-TRANSITIONEDGE-1)
				startx = world.maxx-TRANSITIONEDGE-1
				endy = rand(TRANSITIONEDGE, world.maxy-TRANSITIONEDGE)
				endx = TRANSITIONEDGE
			if(SOUTH)
				starty = TRANSITIONEDGE+1
				startx = rand(TRANSITIONEDGE+1, world.maxx-TRANSITIONEDGE-1)
				endy = world.maxy-TRANSITIONEDGE
				endx = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
			if(WEST)
				starty = rand(TRANSITIONEDGE+1, world.maxy-TRANSITIONEDGE-1)
				startx = TRANSITIONEDGE+1
				endy = rand(TRANSITIONEDGE, world.maxy-TRANSITIONEDGE)
				endx = world.maxx-TRANSITIONEDGE

		var/randomz = pick(affecting_z)
		var/turf/startloc = locate(startx, starty, randomz)
		var/turf/endloc = locate(endx, endy, randomz)
		var/obj/effect/space_dust/D = new dust_type(startloc)
		D.setDir(global.reverse_dir[startside])
		walk_towards(D, endloc, 1)

/obj/effect/space_dust
	name = "Space Dust"
	desc = "Dust in space."
	icon = 'icons/obj/meteor.dmi'
	icon_state = "dust"
	density = 1
	anchored = 1
	var/strength = 2	// legacy_ex_act severity number
	var/life = 2	// How many things we hit before qdel(src)

/obj/effect/space_dust/weak
	strength = 3
	life = 1

/obj/effect/space_dust/strong
	strength = 1
	life = 6

/obj/effect/space_dust/super
	strength = 1
	life = 40

/obj/effect/space_dust/Destroy()
	walk(src, 0)	// Because we might have called walk_towards, we must stop the walk loop or BYOND keeps an internal reference to us forever.
	return ..()

/obj/effect/space_dust/Bump(atom/A)
	. = ..()
	hit(A)

/obj/effect/space_dust/proc/hit(atom/A)
	if(prob(50))
		for(var/mob/M in range(10, src))
			if(!M.stat && !istype(M, /mob/living/silicon/ai))
				shake_camera(M, 3, 1)
	if (A)
		playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)
		LEGACY_EX_ACT(A, strength, null)

		life--
		if(life <= 0)
			walk(src,0)
			qdel(src)
			return

/obj/effect/space_dust/Bumped(atom/A)
	hit(A)
	return

/obj/effect/space_dust/legacy_ex_act(severity)
	qdel(src)
	return
