/datum/radiation_wave
	/// source turf
	var/turf/source
	/// turfs, associated to power
	var/list/turfs
	/// dirs of spread
	var/list/dirs

	/// current cycles - this determines our current falloff-applied power. starts at 0, meaning 3x3 = 0 dist, not 1x1.
	var/cycles
	/// initial power
	var/power
	/// falloff rate as a multipier
	var/falloff_modifier = 1 
	
	/// turfs next, associated to power
	var/list/turfs_next
	/// dirs of spread next
	var/list/dirs_next
	
/datum/radiation_wave/New(turf/source, power, falloff_modifier = RAD_FALLOFF_NORMAL)
	src.source = source
	src.power = power
	src.falloff_modifier = falloff_modifier
	SSradiation.waves += src

/datum/radiation_wave/Destroy()
	SSradiation.waves -= src
	return ..()

/datum/radiation_wave/proc/start()
	cycles = 0
	// we have to stagger a bit, so we preprocess *part* of a 3x3.
	var/after_center = irradiate_turf(source, power)
	// north and south are slightly narrower to prevent overlap.
	turfs = list()
	dirs = list()
	var/turf/irradiating = get_step(source, NORTH)
	var/atom/movable/AM
	if(!isnull(irradiating))
		turfs[irradiating] = after_center
		dirs += NORTH
	irradiating = get_step(source, SOUTH)
	if(!isnull(irradiating))
		turfs[irradiating] = after_center
		dirs += SOUTH
	// east and west aren't, but to prevent diagonal leakage, 
	// we manually get their resistances.
	var/power_east
	irradiating = get_step(source, EAST)
	if(!isnull(irradiating))
		turfs[irradiating] = after_center
		dirs += EAST
		power_east = after_center * irradiating.rad_insulation
		for(AM as anything in irradiating)
			power_east *= AM.rad_insulation
	var/power_west
	irradiating = get_step(source, WEST)
	if(!isnull(irradiating))
		turfs[irradiating] = after_center
		dirs += WEST
		power_west = after_center * irradiating.rad_insulation
		for(AM as anything in irradiating)
			power_west *= AM.rad_insulation
	// and then make emissions on diagonals
	if(power_east)
		irradiating = get_step(source, NORTHEAST)
		if(!isnull(irradiating))
			turfs[irradiating] = power_east
			dirs += EAST
		irradiating = get_step(source, SOUTHEAST)
		if(!isnull(irradiating))
			turfs[irradiating] = power_east
			dirs += EAST
	if(power_west)
		irradiating = get_step(source, NORTHWEST)
		if(!isnull(irradiating))
			turfs[irradiating] = power_west
			dirs += WEST
		irradiating = get_step(source, SOUTHWEST)
		if(!isnull(irradiating))
			turfs[irradiating] = power_west
			dirs += WEST

	turfs_next = list()
	dirs_next = list()

#warn handle RAD_BACKGROUND_RADIATION in above start().

/datum/radiation_wave/proc/irradiate_turf(turf/T, power)
	. = power * T.rad_insulation
	T.rad_act(power, src)
	var/atom/movable/AM
	for(AM as anything in T)
		AM.rad_act(power, src)
		SEND_SIGNAL(AM, COMSIG_ATOM_RAD_PULSE_ITERATE, power, src)
		. *= AM.rad_insulation

/**
 * returns TRUE / FALSE based on if we're completed.
 */
/datum/radiation_wave/proc/iterate(ticklimit)
	var/i
	var/turf/T // current
	var/turf/F // forwards
	var/dir_diag
	var/power
	var/power_next
	var/atom/movable/AM
	var/dir
	var/inverse_square_factor = 1 / (2 ** (falloff_modifier * cycles))
	
	for(i in length(turfs) to 1 step -1)
		T = turfs[i]
		power = turfs[T]
		dir = dirs[i]

		power_next = irradiate_turf(T, power * inverse_square_factor)

		if(power_next < RAD_BACKGROUND_RADIATION)
			continue
		
		F = get_step(T, dir)
		if(!isnull(F))
			turfs_next[F] = max(turfs_next[F], power_next)
			dirs_next[F] = dir
		dir_diag = turn(dir, 45)
		F = get_step(T, dir_diag)
		if(!isnull(F))
			turfs_next[F] = max(turfs_next[F], power_next)
			dirs_next[F] = dir_diag
		dir_diag = turn(dir, -45)
		F = get_step(T, dir_diag)
		if(!isnull(F))
			turfs_next[F] = max(turfs_next[F], power_next)
			dirs_next[F] = dir_diag

		if(TICK_USAGE > ticklimit)	
			break
	
	turfs.len -= length(turfs) - i
	dirs.len -= length(turfs) - i
	++cycles
	return !length(turfs) && cycles < RAD_MAXIMUM_CYCLES

/datum/radiation_wave/proc/next()
	turfs = turfs_next
	dirs = dirs_next
	turfs_next = list()
	dirs_next = list()
