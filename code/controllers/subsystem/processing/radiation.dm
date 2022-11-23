PROCESSING_SUBSYSTEM_DEF(radiation)
	name = "Radiation"
	subsystem_flags = SS_NO_INIT | SS_BACKGROUND
	wait = 1 SECONDS

	/// atom refs we warned about already
	var/list/warned_atoms = list()

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

#warn impl

/*
	if(!SSradiation.can_fire)
		return
	var/area/A = get_area(source)
	var/atom/nested_loc = source.loc
	var/spawn_waves = TRUE
	while(nested_loc != A)
		if(nested_loc.rad_flags & RAD_PROTECT_CONTENTS)
			spawn_waves = FALSE
			break
		nested_loc = nested_loc.loc
	if(spawn_waves)
		for(var/dir in GLOB.cardinals)
			new /datum/radiation_wave(source, dir, intensity, range_modifier, can_contaminate)

		var/static/last_huge_pulse = 0
		if(intensity > 3000 && world.time > last_huge_pulse + 200)
			last_huge_pulse = world.time
			log = TRUE

	var/list/things = get_rad_contents(source) //copypasta because I don't want to put special code in waves to handle their origin
	for(var/k in 1 to things.len)
		var/atom/thing = things[k]
		if(!thing)
			continue
		thing.rad_act(intensity)

	if(log)
		var/turf/_source_T = get_turf(source)
		log_game("Radiation pulse with intensity: [intensity] and range modifier: [range_modifier] in [loc_name(_source_T)][spawn_waves ? "" : " (contained by [nested_loc.name])"]")
	return TRUE
*/

/**
 * does our best faith attempt at irradiating a whole zlevel without lagging the server to death
 */
/datum/controller/subsystem/processing/radiation/proc/z_radiation(turf/T, z, intensity, falloff_modifier, log, can_contaminate)
	if(!T && !z)
		CRASH("need either turf or z")
	if(!z)
		z = T.z

#warn impl
