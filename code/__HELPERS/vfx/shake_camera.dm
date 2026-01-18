/**
 * Shakes the camera of any client watching from an atom's perspective.
 * * The duration argument is treated as a suggestion.
 * * The strength argument is in tiles.
 *
 * @params
 * * duration - how long to do it for
 * * strength - how much to shake max, in **tiles**
 * * iterations - forced iterations amount, otherwise automatic
 */
/proc/shake_camera(atom/movable/AM, duration, strength, iterations)
	if(!AM || isEye(AM) || isAI(AM))
		return
	if(ismob(AM))
		var/mob/M = AM
		if(!IS_CONSCIOUS(M))
			return
	if(!AM.self_perspective)
		return
	for(var/client/C in AM.self_perspective.get_clients())
		shake_camera_direct(C, duration, strength)

/**
 * * The duration argument is treated as a suggestion.
 * * The strength argument is in tiles.
 */
/proc/shake_camera_direct(client/C, duration = 0.3 SECONDS, strength = 0.5, iterations)
	var/min = -strength
	var/max = strength
	var/old_x = C.pixel_x
	var/old_y = C.pixel_y
	if(!iterations)
		iterations = duration / (0.15 SECONDS)
	iterations = clamp(iterations, 1, 15)
	var/delay = min(duration / (iterations + 1), 0.5 SECONDS)
	animate(C, pixel_x = rand(min, max), pixel_y = rand(min, max), time = delay, flags = ANIMATION_PARALLEL)
	for(var/i in 2 to iterations)
		animate(pixel_x = rand(min, max), pixel_y = rand(min, max), time = delay)
	animate(pixel_x = old_x, pixel_y = old_y, time = delay)

	// TODO: implement iterations
	for(var/i in 1 to duration)
		if(i == 1)
			animate(C, pixel_x = rand(min, max), pixel_y = rand(min, max), time = 1.25)
		else
			animate(pixel_x = rand(min, max), pixel_y = rand(min, max), time = 1.25)
	animate(pixel_x = old_x, pixel_y = old_y, time = 1.25)

/**
 * * The duration argument is treated as a suggestion.
 * * The strength argument is in tiles.
 */
/proc/shake_camera_of_nearby_players(atom/center, range, duration, strength, iterations)
	for(var/mob/maybe as anything in GLOB.player_list)
		if(get_dist(maybe, center) > range)
			continue
		shake_camera_direct(maybe.client, duration, strength)
