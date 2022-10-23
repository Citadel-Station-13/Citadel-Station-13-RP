/**
 * Shakes the camera of any client watching from an atom's perspective.
 */
/proc/shake_camera(atom/movable/AM, duration, strength = 1)
	if(!AM || isEye(AM) || isAI(AM))
		return
	if(ismob(AM))
		var/mob/M = AM
		if(!IS_CONSCIOUS(M))
			return
	if(!AM.self_perspective)
		return
	for(var/client/C in AM.self_perspective.GetClients())
		var/min = -world.icon_size * strength
		var/max = world.icon_size * strength
		var/old_x = C.pixel_x
		var/old_y = C.pixel_y
		for(var/i in 1 to duration)
			if(i == 1)
				animate(C, pixel_x = rand(min, max), pixel_y = rand(min, max), time = 1)
			else
				animate(pixel_x = rand(min, max), pixel_y = rand(min, max), time = 1)
		animate(pixel_x = old_x, pixel_y = old_y, time = 1)
