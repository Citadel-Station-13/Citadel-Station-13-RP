/datum/radiation_wave
	/// source turf
	var/turf/source
	/// turfs, associated to power
	var/list/turfs
	/// dirs of spread
	var/list/dirs

	/// current cycles
	var/cycles
	/// initial power
	var/power 
	
	/// turfs next, associated to power
	var/list/turfs_next
	/// dirs of spread next
	var/list/dirs_next
	
/datum/radiation_wave/New(turf/source, power)
	src.source = source
	src.power = power

/datum/radiation_wave/proc/start()
	cycles = 0
	// we have to stagger a bit, so we preprocess *part* of a 3x3.
	var/after_center = irradiate_turf(source, power)
	// north and south are slightly narrower to prevent overlap.
	turfs = list()
	dirs = list()
	var/turfs/irradiating = get_step(source, NORTH)
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
	var/turf/S // side
	var/power
	var/power_next
	var/atom/movable/AM
	var/dirs
	
	for(i in length(turf) to 1 step -1)
		T = turf[i]
		power = turf[T]
		dir = dirs[i]

		power_next = irradiate_turf(T, power)
		
		F = get_step(T, dir)
		if(!isnull(F))
			turfs_next[F] = max(turfs_next[F], power_next)
			dirs_next[F] = dir
		F = get_step(T, turn(dir, 90))
		if(!isnull(F))
			turfs_next[F] = max(turfs_next[F], power_next)
			dirs_next[F] = turn(dir, 90)
		F = get_step(T, turn(dir, -90))
		if(!isnull(F))
			turfs_next[F] = max(turfs_next[F], power_next)
			dirs_next[F] = turn(dir, -90)

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


/datum/radiation_wave/contaminating
	/// remaining contamination
	var/contamination
