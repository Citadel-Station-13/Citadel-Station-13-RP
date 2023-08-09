/turf/simulated/wall/proc/can_rot()
	return integrity_flags & INTEGRITY_INDESTRUCTIBLE

/turf/simualted/wall/proc/is_rotting()
	return locate(/obj/effect/overlay/wallrot) in src

/turf/simulated/wall/proc/rot()
	if(is_rotting())
		return
	for(var/i in 1 to rand(2, 3))
		new /obj/effect/overlay/wallrot(src)
