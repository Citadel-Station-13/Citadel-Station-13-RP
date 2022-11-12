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

/datum/radiation_wave/New(atom/source, turf/starting, dir, intensity = 0, falloff_modifier = RAD_FALLOFF_DEFAULT, can_contaminate = TRUE)
	src.source = source
	src.current = starting
	src.dir = dir
	src.starting_intensity = src.current_intensity = intensity
	src.falloff_modifier = falloff_modifier
	src.can_contaminate = can_contaminate

	START_PROCESSING(SSradiation, src)

/datum/radiation_wave/Destroy()
	STOP_PROCESSING(SSradiation, src)
	..()
	return QDEL_HINT_IWILLGC



/datum/radiation_wave/process(delta_time)
	master_turf = get_step(master_turf, move_dir)
	if(!master_turf)
		qdel(src)
		return
	steps++
	var/list/atoms = get_rad_atoms()

	var/strength
	if(steps>1)
		strength = INVERSE_SQUARE(intensity, max(range_modifier*steps, 1), 1)
	else
		strength = intensity

	if(strength<RAD_BACKGROUND_RADIATION)
		qdel(src)
		return

	if(radiate(atoms, FLOOR(min(strength,remaining_contam), 1)))
		//oof ow ouch
		remaining_contam = max(0,remaining_contam-((min(strength,remaining_contam)-RAD_MINIMUM_CONTAMINATION) * RAD_CONTAMINATION_STR_COEFFICIENT))
	check_obstructions(atoms) // reduce our overall strength if there are radiation insulators

/datum/radiation_wave/proc/get_rad_atoms()
	var/list/atoms = list()
	var/distance = steps
	var/cmove_dir = move_dir
	var/cmaster_turf = master_turf

	if(cmove_dir == NORTH || cmove_dir == SOUTH)
		distance-- //otherwise corners overlap

	atoms += get_rad_contents(cmaster_turf)

	var/turf/place
	for(var/dir in __dirs) //There should be just 2 dirs in here, left and right of the direction of movement
		place = cmaster_turf
		for(var/i in 1 to distance)
			place = get_step(place, dir)
			if(!place)
				break
			atoms += get_rad_contents(place)

	return atoms

/datum/radiation_wave/proc/check_obstructions(list/atoms)
	var/width = steps
	var/cmove_dir = move_dir
	if(cmove_dir == NORTH || cmove_dir == SOUTH)
		width--
	width = 1+(2*width)

	for(var/k in 1 to atoms.len)
		var/atom/thing = atoms[k]
		if(!thing)
			continue
		if (SEND_SIGNAL(thing, COMSIG_ATOM_RAD_WAVE_PASSING, src, width) & COMPONENT_RAD_WAVE_HANDLED)
			continue
		if (thing.rad_insulation != RAD_NO_INSULATION)
			intensity *= (1-((1-thing.rad_insulation)/width))

/datum/radiation_wave/proc/radiate(list/atoms, strength)
	var/can_contam = strength >= RAD_MINIMUM_CONTAMINATION
	var/list/contam_atoms = list()
	for(var/k in 1 to atoms.len)
		var/atom/thing = atoms[k]
		if(!thing)
			continue
		thing.rad_act(strength)

		// This list should only be for types which don't get contaminated but you want to look in their contents
		// If you don't want to look in their contents and you don't want to rad_act them:
		// modify the ignored_things list in __HELPERS/radiation.dm instead
		var/static/list/blacklisted = typecacheof(list(
			/turf,
			/obj/structure/cable,
			/obj/machinery/atmospherics,
			/obj/item/ammo_casing,
			/obj/singularity
			))
		if(!can_contaminate || blacklisted[thing.type])
			continue
		if((thing.rad_flags & RAD_NO_CONTAMINATE) || SEND_SIGNAL(thing, COMSIG_ATOM_RAD_CONTAMINATING, strength) & COMPONENT_BLOCK_CONTAMINATION)
			continue
		contam_atoms += thing
	var/did_contam = 0
	if(can_contam && contam_atoms.len)
		var/rad_strength = ((strength-RAD_MINIMUM_CONTAMINATION) * RAD_CONTAMINATION_STR_COEFFICIENT)/contam_atoms.len
		for(var/A in contam_atoms)
			var/atom/thing = A
			thing.AddComponent(/datum/component/radioactive, rad_strength, source)
			did_contam = 1
	return did_contam
