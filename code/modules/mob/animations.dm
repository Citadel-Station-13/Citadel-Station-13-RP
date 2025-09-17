/*
adds a dizziness amount to a mob
use this rather than directly changing var/dizziness
since this ensures that the dizzy_process proc is started
currently only humans get dizzy

value of dizziness ranges from 0 to 1000
below 100 is not dizzy
*/

/mob/proc/make_dizzy(var/amount)
	// for the moment, only humans get dizzy
	if(!istype(src, /mob/living/carbon/human))
		return

	dizziness = min(1000, dizziness + amount)	// store what will be new value
													// clamped to max 1000
	if(dizziness > 100 && !is_dizzy)
		spawn(0)
			dizzy_process()


/*
dizzy process - wiggles the client's pixel offset over time
spawned from make_dizzy(), will terminate automatically when dizziness gets <100
note dizziness decrements automatically in the mob's Life() proc.
*/
/mob/proc/dizzy_process()
	is_dizzy = 1
	while(dizziness > 100)
		if(client)
			var/amplitude = dizziness*(sin(dizziness * 0.044 * world.time) + 1) / 70
			client.pixel_x = amplitude * sin(0.008 * dizziness * world.time)
			client.pixel_y = amplitude * cos(0.008 * dizziness * world.time)

		sleep(1)
	//endwhile - reset the pixel offsets to zero
	is_dizzy = 0
	if(client)
		client.pixel_x = 0
		client.pixel_y = 0

/mob/proc/make_jittery(var/amount)
	if(!istype(src, /mob/living/carbon/human)) // for the moment, only humans get dizzy
		return

	jitteriness = min(1000, jitteriness + amount)	// store what will be new value
													// clamped to max 1000

	var/effective_jitteriness = get_effective_impairment_power_jitter()
	if(effective_jitteriness > 100 && !is_jittery)
		spawn(0)
			jittery_process()

/mob/proc/jittery_process()
	if(IS_DEAD(src))//Dead people dont twitch around
		return

	is_jittery = 1
	var/effective_jitteriness = get_effective_impairment_power_jitter()
	while(effective_jitteriness > 100)
		effective_jitteriness = get_effective_impairment_power_jitter()
		var/amplitude = min(4, effective_jitteriness / 100)
		pixel_x = get_managed_pixel_x() + rand(-amplitude, amplitude)
		pixel_y = get_managed_pixel_y()  + rand(-amplitude/3, amplitude/3)

		sleep(1)
	is_jittery = 0
	reset_pixel_offsets()

/mob/proc/update_floating(dense_object=0)

	if(anchored||buckled)
		make_floating(0)
		return
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.flying)
			make_floating(1)
			return
	var/turf/turf = get_turf(src)
	if(!istype(turf,/turf/space))
		var/area/A = turf.loc
		if(istype(A) && A.has_gravity)
			make_floating(0)
			return
		else if (Check_Shoegrip())
			make_floating(0)
			return
		else
			make_floating(1)
			return

	if(dense_object && Check_Shoegrip())
		make_floating(0)
		return

	make_floating(1)
	return

/mob/proc/make_floating(var/n)
	if(buckled)
		if(is_floating)
			stop_floating()
		return
	floatiness = n

	if(floatiness && !is_floating)
		start_floating()
	else if(!floatiness && is_floating)
		stop_floating()

/mob/proc/start_floating()

	is_floating = 1

	var/amplitude = 2 //maximum displacement from original position
	var/period = 36 //time taken for the mob to go up >> down >> original position, in deciseconds. Should be multiple of 4

	var/top = get_standard_pixel_y_offset() + amplitude
	var/bottom = get_standard_pixel_y_offset() - amplitude
	var/half_period = period / 2
	var/quarter_period = period / 4

	animate(src, pixel_y = top, time = quarter_period, easing = SINE_EASING | EASE_OUT, loop = -1)		//up
	animate(pixel_y = bottom, time = half_period, easing = SINE_EASING, loop = -1)						//down
	animate(pixel_y = get_standard_pixel_y_offset(), time = quarter_period, easing = SINE_EASING | EASE_IN, loop = -1)			//back

/mob/proc/stop_floating()
	animate(src, pixel_y = get_standard_pixel_y_offset(), time = 5, easing = SINE_EASING | EASE_IN) //halt animation
	//reset the pixel offsets to zero
	is_floating = 0

/atom/movable/proc/fade_towards(atom/A,var/time = 2)
	set waitfor = FALSE

	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/pixel_z_diff = 0
	var/direction = get_dir(src, A)
	if(direction & NORTH)
		pixel_y_diff = 32
	else if(direction & SOUTH)
		pixel_y_diff = -32

	if(direction & EAST)
		pixel_x_diff = 32
	else if(direction & WEST)
		pixel_x_diff = -32

	if(!direction) // On top of?
		pixel_z_diff = -8

	var/base_pixel_x = initial(pixel_x)
	var/base_pixel_y = initial(pixel_y)
	var/base_pixel_z = initial(pixel_z)
	var/initial_alpha = alpha
	var/mob/mob = src
	if(istype(mob))
		base_pixel_x = mob.base_pixel_x
		base_pixel_y = mob.base_pixel_y

	animate(src, alpha = 0, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, pixel_z = pixel_z + pixel_z_diff, time = time)
	sleep(time+1) //So you can wait on this proc to finish if you want to time your next steps
	pixel_x = base_pixel_x
	pixel_y = base_pixel_y
	pixel_z = base_pixel_z
	alpha = initial_alpha

// Similar to attack animations, but in reverse and is longer to act as a telegraph.
/atom/movable/proc/do_windup_animation(atom/A, windup_time)
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/direction = get_dir(src, A)
	if(direction & NORTH)
		pixel_y_diff = -8
	else if(direction & SOUTH)
		pixel_y_diff = 8

	if(direction & EAST)
		pixel_x_diff = -8
	else if(direction & WEST)
		pixel_x_diff = 8

	var/base_pixel_x = initial(pixel_x)
	var/base_pixel_y = initial(pixel_y)
	var/mob/mob = src
	if(istype(mob))
		base_pixel_x = mob.base_pixel_x
		base_pixel_y = mob.base_pixel_y

	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = windup_time - 2)
	animate(pixel_x = base_pixel_x, pixel_y = base_pixel_y, time = 2)


/atom/movable/proc/do_attack_animation(atom/A)
	animate_swing_at_target(A)

/mob/living/do_attack_animation(atom/A, no_attack_icons = FALSE)
	..()
	if(no_attack_icons)
		return FALSE
	var/obj/item/held = get_active_held_item()
	if(!isnull(held))
		A.animate_hit_by_weapon(src, held)
	else
		A.animate_hit_by_attack(src)

/mob/proc/spin(spintime, speed)
	if(speed < world.tick_lag)
		return		// no.
	spawn()
		var/D = dir
		while(spintime >= speed)
			sleep(speed)
			switch(D)
				if(NORTH)
					D = EAST
				if(SOUTH)
					D = WEST
				if(EAST)
					D = SOUTH
				if(WEST)
					D = NORTH
			setDir(D)
			spintime -= speed
