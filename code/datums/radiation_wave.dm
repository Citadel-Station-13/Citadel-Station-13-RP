/turf
	var/datum/radiation_wave/rad_wave_north
	var/datum/radiation_wave/rad_wave_south
	var/datum/radiation_wave/rad_wave_east
	var/datum/radiation_wave/rad_wave_west

/datum/radiation_wave
	/// source atom - can be null
	var/atom/source
	/// current center of wave
	var/turf/current
	/// how far we've moved
	var/steps = 0
	/// original intensity
	var/starting_intensity
	/// current intensity
	var/current_intensity
	/// falloff modifier - 0.5 is half falloff, etc
	var/falloff_modifier
	/// direction of movement
	var/dir
	/// can we cause contaminate?
	var/can_contaminate
	/// remaining contamination
	var/remaining_contam
	/// mobs we already hit - we REALLY do not want to double hit mobs and turn 1500 intensity one-off to lethal.
	var/list/hit_mobs

/datum/radiation_wave/New(atom/source, turf/starting, dir, intensity = 0, falloff_modifier = RAD_FALLOFF_NORMAL, can_contaminate = TRUE)
	switch(dir)
		if(NORTH)
			if(starting.rad_wave_north)
				starting.rad_wave_north.starting_intensity += intensity
				starting.rad_wave_north.current_intensity += intensity
				starting.rad_wave_north.remaining_contam += intensity
				qdel(src)
				return
			else
				starting.rad_wave_north = src
		if(SOUTH)
			if(starting.rad_wave_south)
				starting.rad_wave_south.starting_intensity += intensity
				starting.rad_wave_south.current_intensity += intensity
				starting.rad_wave_north.remaining_contam += intensity
				qdel(src)
				return
			else
				starting.rad_wave_south = src
		if(EAST)
			if(starting.rad_wave_east)
				starting.rad_wave_east.starting_intensity += intensity
				starting.rad_wave_east.current_intensity += intensity
				starting.rad_wave_north.remaining_contam += intensity
				qdel(src)
				return
			else
				starting.rad_wave_east = src
		if(WEST)
			if(starting.rad_wave_west)
				starting.rad_wave_west.starting_intensity += intensity
				starting.rad_wave_west.current_intensity += intensity
				starting.rad_wave_north.remaining_contam += intensity
				qdel(src)
				return
			else
				starting.rad_wave_west = src
	src.source = source
	src.current = starting
	src.dir = dir
	src.starting_intensity = src.current_intensity = src.remaining_contam = intensity
	src.falloff_modifier = falloff_modifier
	src.can_contaminate = can_contaminate
	hit_mobs = list()
	START_PROCESSING(SSradiation, src)

/datum/radiation_wave/Destroy()
	STOP_PROCESSING(SSradiation, src)
	hit_mobs = null
	..()
	return QDEL_HINT_IWILLGC

/datum/radiation_wave/process(delta_time)
	if(!steps)
		switch(dir)
			if(NORTH)
				current.rad_wave_north = null
			if(SOUTH)
				current.rad_wave_south = null
			if(EAST)
				current.rad_wave_east = null
			if(WEST)
				current.rad_wave_west = null
	current = get_step(current, dir)
	if(!current)
		qdel(src)
		return
	++steps
	var/list/atom/atoms = atoms_within_line()
	var/effective_steps = max(falloff_modifier * steps, 1)
	var/strength = steps > 1? INVERSE_SQUARE(current_intensity, effective_steps, 1) : current_intensity
	if(strength < RAD_BACKGROUND_RADIATION)
		qdel(src)
		return
	var/contaminated = radiate(atoms, strength)
	if(contaminated)
		remaining_contam = max(0, remaining_contam - contaminated)
	process_obstructions(atoms) // reduce our overall strength if there are radiation insulators

/datum/radiation_wave/proc/atoms_within_line()
	. = list()
	var/cmove_dir = dir
	// prevent corners overlapping
	var/cdist = (cmove_dir & (NORTH|SOUTH)) ? (steps - 1) : steps
	var/turf/cturf = current
	// get current
	. += get_rad_contents(cturf)
	// scan left
	var/turf/cscan = cturf
	var/dscan = turn(cmove_dir, 90)
	for(var/i in 1 to cdist)
		cscan = get_step(cscan, dscan)
		if(isnull(cscan))
			break
		. += get_rad_contents(cscan)
	// scan right
	cscan = cturf
	dscan = turn(cmove_dir, -90)
	for(var/i in 1 to cdist)
		cscan = get_step(cscan, dscan)
		if(isnull(cscan))
			break
		. += get_rad_contents(cscan)

/**
 * reduce our intensity based on stuff with radiation insulation
 * insulating objects have higher effect to us the closer they are to our start
 * which is a shit model of radiation but hey it's faster than
 * fully raycasting everything (kinda) (probably)
 */
/datum/radiation_wave/proc/process_obstructions(list/atoms)
	var/cwidth = 1 + ((dir & (NORTH|SOUTH)) ? (steps - 1) : steps) * 2
	for(var/atom/A as anything in atoms)
		if(SEND_SIGNAL(A, COMSIG_ATOM_RAD_WAVE_PASSING, src, cwidth) & COMPONENT_RAD_WAVE_HANDLED)
			continue
		if(A.rad_insulation != RAD_INSULATION_NONE)
			current_intensity *= (1-((1-A.rad_insulation)/cwidth))

/**
 * hits atoms with radiation wave
 * hits amount of contamination inflicted
 */
/datum/radiation_wave/proc/radiate(list/atoms, strength)
	var/cannot_contam = strength < RAD_MINIMUM_CONTAMINATION
	var/list/contaminating = list()
	for(var/atom/A as anything in atoms)
		A.rad_act(strength, src)
		if(ismob(A))
			if(hit_mobs[A])
				continue
			hit_mobs[A] = TRUE	// let's NOT doublehit mobs
		if(radiation_infect_ignore[A.type] || cannot_contam)
			continue
		if((A.rad_flags & RAD_NO_CONTAMINATE) || (SEND_SIGNAL(A, COMSIG_ATOM_RAD_CONTAMINATING, strength) & COMPONENT_BLOCK_CONTAMINATION))
			continue
		contaminating += A
	. = 0
	var/stack_to = strength * RAD_CONTAMINATION_STACK_COEFFICIENT
	if(!cannot_contam && length(contaminating))
		var/contam_strength = min(remaining_contam / length(contaminating), starting_intensity * RAD_CONTAMINATION_MAXIMUM_OBJECT_RATIO)
		for(var/atom/A as anything in contaminating)
			A.AddComponent(/datum/component/radioactive, contam_strength, source, max_stack = stack_to)
		. = contam_strength * length(contaminating)
