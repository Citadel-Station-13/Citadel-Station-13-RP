//wip: rework this file and sort it under ./step_triggers/

/* Simple object type, calls a proc when "stepped" on by something */



/* Tosses things in a certain direction */

/obj/effect/step_trigger/thrower
	var/direction = SOUTH // the direction of throw
	var/tiles = 3	// if 0: forever until atom hits a stopper
	var/immobilize = 1 // if nonzero: prevents mobs from moving while they're being flung
	var/speed = 1	// delay of movement
	var/facedir = 0 // if 1: atom faces the direction of movement
	var/nostop = 0 // if 1: will only be stopped by teleporters
	var/list/affecting = list()

	Trigger(var/atom/A)
		if(!A || !istype(A, /atom/movable))
			return
		var/atom/movable/AM = A
		var/curtiles = 0
		var/stopthrow = 0
		for(var/obj/effect/step_trigger/thrower/T in orange(2, src))
			if(AM in T.affecting)
				return

		if(ismob(AM))
			var/mob/M = AM
			if(immobilize)
				M.canmove = 0

		affecting.Add(AM)
		while(AM && !stopthrow)
			if(tiles)
				if(curtiles >= tiles)
					break
			if(AM.z != src.z)
				break

			curtiles++

			sleep(speed)

			// Calculate if we should stop the process
			if(!nostop)
				for(var/obj/effect/step_trigger/T in get_step(AM, direction))
					if(T.stop_throw && T != src)
						stopthrow = 1
						break
			else
				for(var/obj/effect/step_trigger/teleporter/T in get_step(AM, direction))
					if(T.stop_throw)
						stopthrow = 1
						break

			if(AM)
				var/predir = AM.dir
				step(AM, direction)
				if(!facedir)
					AM.setDir(predir)



		affecting.Remove(AM)

		if(ismob(AM))
			var/mob/M = AM
			if(immobilize)
				M.canmove = 1

/* Stops things thrown by a thrower, doesn't do anything */

/obj/effect/step_trigger/stopper

/* Teleporter which simulates falling out of the sky. */

/obj/effect/step_trigger/teleporter/planetary_fall
	var/datum/planet/planet = null

// First time setup, which planet are we aiming for?
/obj/effect/step_trigger/teleporter/planetary_fall/proc/find_planet()
	return

/obj/effect/step_trigger/teleporter/planetary_fall/trigger(var/atom/movable/A)
	if(!planet)
		find_planet()

	if(planet)
		if(!planet.planet_floors.len)
			message_admins("ERROR: planetary_fall step trigger's list of outdoor floors was empty.")
			return
		var/turf/simulated/T = null
		var/safety = 100 // Infinite loop protection.
		while(!T && safety)
			var/turf/simulated/candidate = pick(planet.planet_floors)
			if(!istype(candidate) || istype(candidate, /turf/simulated/sky))
				safety--
				continue
			else if(candidate && !candidate.outdoors)
				safety--
				continue
			else
				T = candidate
				break

		if(!T)
			message_admins("ERROR: planetary_fall step trigger could not find a suitable landing turf.")
			return

		if(isobserver(A))
			A.forceMove(T) // Harmlessly move ghosts.
			return

		A.forceMove(T)
		// Living things should probably be logged when they fall...
		if(isliving(A))
			message_admins("\The [A] fell out of the sky.")
		// ... because they're probably going to die from it.
		A.fall_impact(T, 42, 90, FALSE, TRUE)	//You will not be defibbed from this.
	else
		message_admins("ERROR: planetary_fall step trigger lacks a planet to fall onto.")
		return
