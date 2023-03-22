/datum/radiation_burst
	/// numbers of emitters we're from
	var/emitter_count = 1
	/// intensity
	var/intensity
	/// falloff
	var/falloff
	/// max intensity
	var/highest

/datum/radiation_burst/New(intensity, falloff)
	src.intensity = src.highest = intensity
	src.falloff = falloff

/datum/radiation_wave_legacy
	/// current center of wave
	var/turf/current
	/// how far we've moved
	var/steps = 0
	/// original intensity
	var/starting_intensity
	/// maximum intensity of this collated wave; used to prevent radiation cascades
	var/max_intensity
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
	/// how many emitters of atleast RAD_MOB_ACT_PROTECTION we're from
	var/relevant_count

/datum/radiation_wave_legacy/New(turf/starting, dir, intensity = 0, falloff_modifier = RAD_FALLOFF_NORMAL, max_intensity, can_contaminate = TRUE, relevant_count = 1, contam_left)
	src.current = starting
	src.dir = dir
	src.starting_intensity = src.current_intensity = intensity
	src.max_intensity = max_intensity || intensity
	src.remaining_contam = contam_left || intensity
	src.falloff_modifier = falloff_modifier
	src.can_contaminate = can_contaminate
	src.relevant_count = relevant_count
	hit_mobs = list()
	SSradiation.waves += src

/datum/radiation_wave_legacy/Destroy()
	SSradiation.waves -= src
	hit_mobs = null
	..()
	return QDEL_HINT_IWILLGC

/**
 * return true if not deleted
 */
/datum/radiation_wave_legacy/proc/propagate()
	current = get_step(current, dir)
	if(!current)
		qdel(src)
		return FALSE
	++steps
	var/effective_steps = max(falloff_modifier * steps, 1)
	var/strength = steps > 1? INVERSE_SQUARE(current_intensity, effective_steps, 1) : current_intensity
	if(strength < RAD_BACKGROUND_RADIATION)
		qdel(src)
		return FALSE
	var/list/atom/atoms = atoms_within_line()
	// block **first**
	process_obstructions(atoms)
	// then radiate/contaminate
	var/contaminated = radiate(atoms, strength)
	if(contaminated)
		remaining_contam = max(0, remaining_contam - contaminated)
	return TRUE

/datum/radiation_wave_legacy/proc/atoms_within_line()
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
/datum/radiation_wave_legacy/proc/process_obstructions(list/atoms)
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
/datum/radiation_wave_legacy/proc/radiate(list/atoms, strength)
	var/cannot_contam = strength < RAD_MINIMUM_CONTAMINATION || !can_contaminate || !remaining_contam
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
	if(length(contaminating))
		// maximum we can contaminate them up to
		// var/max_str = min(strength, max_intensity) * RAD_CONTAMINATION_STR_COEFFICIENT
		var/max_str = min(strength, max_intensity) * RAD_CONTAMINATION_STR_COEFFICIENT - RAD_CONTAMINATION_STR_ADJUST
		// how much we're going to apply
		var/apply_str = min(max_str, remaining_contam / length(contaminating), starting_intensity * RAD_CONTAMINATION_MAXIMUM_OBJECT_RATIO)
		if(apply_str <= 0)
			return
		for(var/atom/A as anything in contaminating)
			var/datum/component/radioactive/R = A.GetComponent(/datum/component/radioactive)
			var/effective_stack = (isnull(A.rad_stickiness)? A.rad_insulation : A.rad_stickiness) * max_str	// rad insulation helps against contamination by blocking it too
			if(effective_stack < RAD_CONTAMINATION_MEANINGFUL)
				continue
			if(!R)
				A.AddComponent(/datum/component/radioactive, min(apply_str, effective_stack))
				. += apply_str
			else
				. += R.constructive_interference(effective_stack, apply_str)
