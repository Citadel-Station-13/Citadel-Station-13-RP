PROCESSING_SUBSYSTEM_DEF(radiation)
	name = "Radiation"
	subsystem_flags = SS_NO_INIT | SS_BACKGROUND
	wait = 1 SECONDS

	/// atom refs we warned about already
	var/list/warned_atoms = list()
	/// z radiation listeners - nested list
	var/static/list/z_listeners = list()

/datum/controller/subsystem/processing/radiation/on_max_z_changed(old_z_count, new_z_count)
	var/old = z_listeners.len
	z_listeners.len = new_z_count
	for(var/i in old + 1 to z_listeners.len)
		z_listeners[i] = list()

/datum/controller/subsystem/processing/radiation/proc/warn(datum/component/radioactive/contamination)
	if(!contamination || QDELETED(contamination))
		return
	var/ref = REF(contamination.parent)
	if(warned_atoms[ref])
		return
	warned_atoms[ref] = TRUE
	var/atom/master = contamination.parent
	// SSblackbox.record_feedback("tally", "contaminated", 1, master.type)
	var/msg = "has become contaminated with enough radiation to contaminate other objects. || Source: [contamination.source] || Strength: [contamination.strength]"
	master.investigate_log(msg, INVESTIGATE_RADIATION)

/**
 * todo: comment
 */
/datum/controller/subsystem/processing/radiation/proc/radiation_pulse(turf/T, atom/source, intensity, falloff_modifier, log, can_contaminate = RAD_CONTAMINATION_DEFAULT)
	if(!can_fire)	// we don't care
		return FALSE
	var/atom/nested = source.loc
	if(!nested.loc)
		// we're not going to emit in nullspace at all, don't bother
		return
	var/waves = TRUE
	while(nested.loc)
		if(nested.rad_flags & RAD_BLOCK_CONTENTS)
			waves = FALSE
			break
		nested = nested.loc
	if(!T)
		T = get_turf(source)
	if(waves && T)
		for(var/dir in GLOB.cardinal)
			new /datum/radiation_wave(source, T, dir, intensity, falloff_modifier, can_contaminate)
		var/static/last_huge_pulse = 0
		if(intensity > 1000 && world.time > last_huge_pulse + 10 SECONDS)
			last_huge_pulse = world.time
			log = TRUE
	var/list/things = get_rad_contents(nested)
	for(var/atom/A as anything in things)
		A.rad_act(intensity)
	if(log)
		log_game("Pulse intensity [intensity] falloff [falloff_modifier] in [AREACOORD(T)][waves? "" : " (contained by [nested])"]")
	return TRUE

/**
 * does our best faith attempt at irradiating a whole zlevel without lagging the server to death
 */
/datum/controller/subsystem/processing/radiation/proc/z_radiation(turf/T, z, intensity, falloff_modifier, log, can_contaminate, z_radiate_flags)
	if(!T && !z)
		CRASH("need either turf or z")
	if(!z)
		z = T.z
	// you can tell that this proc is hand-optimized, huh.
	// :skull_crossbones:
	if(z_radiate_flags)
		if(falloff_modifier && T)
			for(var/atom/A as anything in z_listeners[z])
				if(z_radiate_flags & Z_RADIATE_CHECK_AREA_SHIELD)
					var/area/checking = get_area(A)
					if(checking.area_flags & AREA_RAD_SHIELDED)
						continue
				var/dist = get_dist(A, T)
				A.z_rad_act(INVERSE_SQUARE(intensity, dist, 1))
		else
			for(var/atom/A as anything in z_listeners[z])
				if(z_radiate_flags & Z_RADIATE_CHECK_AREA_SHIELD)
					var/area/checking = get_area(A)
					if(checking.area_flags & AREA_RAD_SHIELDED)
						continue
				A.z_rad_act(intensity)

	else
		if(falloff_modifier && T)
			for(var/atom/A as anything in z_listeners[z])
				var/dist = get_dist(A, T)
				A.z_rad_act(INVERSE_SQUARE(intensity, dist, 1))
		else
			for(var/atom/A as anything in z_listeners[z])
				A.z_rad_act(intensity)
