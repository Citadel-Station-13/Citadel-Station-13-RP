/datum/radiation_burst
	var/falloff
	var/intensity
	var/highest
	var/emitter_count

/datum/radiation_burst/New(intensity, falloff)
	src.falloff = falloff
	src.intensity = intensity
	src.highest = intensity
	src.emitter_count = 1

#define SPREAD_LEFT 1
#define SPREAD_RIGHT 2

/datum/radiation_wave
	/// source turf
	var/turf/source
	/// turfs, associated to power
	var/list/turfs
	/// dirs of ray movement
	var/list/dirs
	/// dirs of ray spread:
	var/list/spreads

	/// current cycles - this determines our current falloff-applied power. starts at 0, meaning 3x3 = 0 dist, not 1x1.
	var/cycles
	/// initial power
	var/power
	/// falloff rate as a multipier
	var/falloff_modifier = 1

	/// turfs next, associated to power
	var/list/turfs_next
	/// dirs of movement next
	var/list/dirs_next
	/// dirs of spread next
	var/list/spreads_next

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
	var/after_center = power * irradiate_turf(source, power)
	if(after_center <= RAD_BACKGROUND_RADIATION)
		qdel(src)
		return
	// north and south are slightly narrower to prevent overlap.
	turfs = list()
	dirs = list()
	spreads = list()
	var/turf/irradiating = get_step(source, NORTH)
	var/atom/movable/AM
	if(!isnull(irradiating))
		turfs[irradiating] = after_center
		dirs += NORTH
		spreads += null
	irradiating = get_step(source, SOUTH)
	if(!isnull(irradiating))
		turfs[irradiating] = after_center
		dirs += SOUTH
		spreads += null
	// east and west aren't, but to prevent diagonal leakage,
	// we manually get their resistances.
	var/power_east
	irradiating = get_step(source, EAST)
	if(!isnull(irradiating))
		turfs[irradiating] = after_center
		dirs += EAST
		spreads += null
		power_east = after_center * irradiating.rad_insulation
		for(AM as anything in irradiating)
			power_east *= AM.rad_insulation
	var/power_west
	irradiating = get_step(source, WEST)
	if(!isnull(irradiating))
		turfs[irradiating] = after_center
		dirs += WEST
		spreads += null
		power_west = after_center * irradiating.rad_insulation
		for(AM as anything in irradiating)
			power_west *= AM.rad_insulation
	// and then make emissions on diagonals
	if(power_east > RAD_BACKGROUND_RADIATION)
		irradiating = get_step(source, NORTHEAST)
		if(!isnull(irradiating))
			turfs[irradiating] = power_east
			dirs += EAST
			spreads += SPREAD_LEFT
		irradiating = get_step(source, SOUTHEAST)
		if(!isnull(irradiating))
			turfs[irradiating] = power_east
			dirs += EAST
			spreads += SPREAD_RIGHT
	if(power_west > RAD_BACKGROUND_RADIATION)
		irradiating = get_step(source, NORTHWEST)
		if(!isnull(irradiating))
			turfs[irradiating] = power_west
			dirs += WEST
			spreads += SPREAD_RIGHT
		irradiating = get_step(source, SOUTHWEST)
		if(!isnull(irradiating))
			turfs[irradiating] = power_west
			dirs += WEST
			spreads += SPREAD_LEFT

	turfs_next = list()
	dirs_next = list()
	spreads_next = list()

/**
 * irradiates a turf
 *
 * returns rad insulation
 */
/datum/radiation_wave/proc/irradiate_turf(turf/T, power)
	. = T.rad_insulation * T.rad_insulation_contents
	T.rad_act(power, src)
	SEND_SIGNAL(T, COMSIG_ATOM_RAD_PULSE_ITERATE, power, src)

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
	var/dir
	var/spread
	var/existing
	var/inverse_square_factor = 1 / (2 ** (falloff_modifier * cycles))

	for(i in length(turfs) to 1 step -1)
		T = turfs[i]
		power = turfs[T]
		dir = dirs[i]
		spread = spreads[i]

		power_next = power * irradiate_turf(T, power * inverse_square_factor)

		if(power_next * inverse_square_factor < RAD_BACKGROUND_RADIATION)
			continue

		F = get_step(T, dir)

		if(isnull(F))
			continue

		existing = turfs_next[F]
		if(isnull(existing))
			turfs_next[F] = power_next
			dirs_next += dir
			spreads_next += spread
		else
			turfs_next[F] = max(turfs_next[F], power_next)
		if(spread != SPREAD_RIGHT)
			dir_diag = turn(dir, 45)
			F = get_step(T, dir_diag)
			if(!isnull(F))
				existing = turfs_next[F]
				if(isnull(existing))
					turfs_next[F] = power_next
					dirs_next += dir
					spreads_next += SPREAD_LEFT
				else
					turfs_next[F] = max(turfs_next[F], power_next)
		if(spread != SPREAD_LEFT)
			dir_diag = turn(dir, -45)
			F = get_step(T, dir_diag)
			if(!isnull(F))
				existing = turfs_next[F]
				if(isnull(existing))
					turfs_next[F] = power_next
					dirs_next += dir
					spreads_next += SPREAD_RIGHT
				else
					turfs_next[F] = max(turfs_next[F], power_next)

		if(TICK_USAGE > ticklimit)
			break

	var/length_turfs = length(turfs)
	turfs.len -= length_turfs - i + 1
	dirs.len -= length_turfs - i + 1
	spreads.len -= length_turfs - i + 1
	if(!length(turfs))
		next()
	++cycles
	return !length(turfs) && cycles < RAD_MAXIMUM_CYCLES

/datum/radiation_wave/proc/next()
	turfs = turfs_next
	dirs = dirs_next
	spreads = spreads_next
	turfs_next = list()
	dirs_next = list()
	spreads_next = list()

#undef SPREAD_LEFT
#undef SPREAD_RIGHT
