SUBSYSTEM_DEF(radiation)
	name = "Radiation"
	subsystem_flags = SS_NO_INIT | SS_BACKGROUND
	wait = 1 SECONDS

	/// we alternate between ticking sources and waves
	var/static/alternating = FALSE
	/// atom refs we warned about already
	var/list/warned_atoms = list()
	/// z radiation listeners - nested list
	var/static/list/z_listeners = list()
	/// waves about to be sent out on next tick; list [ turf = list(burst) ]
	var/static/list/queued_waves = list()
	/// sources
	var/static/list/datum/component/radioactive/sources = list()
	/// emitting sources (currentrun)
	var/list/datum/component/radioactive/emitting = list()
	/// pulses
	var/static/list/datum/radiation_pulse/pulses = list()

/datum/controller/subsystem/radiation/fire(resumed)
	if(!resumed)
		emitting = sources.Copy()
	if(length(emitting))
		process_sources()
	if(state != SS_RUNNING)
		return
	else
		// processed full cycle; emit
		flush_queue()
	if(MC_TICK_CHECK)	// if flushing queue pushed us over
		return
	if(length(pulses))
		process_pulses()

/datum/controller/subsystem/radiation/proc/process_sources()
	var/dt = (subsystem_flags & SS_TICKER)? (wait * world.tick_lag) : (wait)
	while(length(emitting))
		var/datum/component/radioactive/R = emitting[1]
		emitting.Cut(1,2)
		R.emit(dt)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/radiation/proc/process_pulses()
	while(length(pulses))
		for(var/datum/radiation_pulse/pulse as anything in pulses)
			pulse.propagate()
			if(MC_TICK_CHECK)
				return

/datum/controller/subsystem/radiation/on_max_z_changed(old_z_count, new_z_count)
	var/old = z_listeners.len
	z_listeners.len = new_z_count
	for(var/i in old + 1 to z_listeners.len)
		z_listeners[i] = list()

/datum/controller/subsystem/radiation/proc/warn(datum/component/radioactive/contamination)
	if(!contamination || QDELETED(contamination))
		return
	var/ref = REF(contamination.parent)
	if(warned_atoms[ref])
		return
	warned_atoms[ref] = TRUE
	var/atom/master = contamination.parent
	// SSblackbox.record_feedback("tally", "contaminated", 1, master.type)
	var/msg = "has become contaminated with enough radiation to contaminate other objects. || Strength: [contamination.strength]"
	master.investigate_log(msg, INVESTIGATE_RADIATION)

/datum/controller/subsystem/radiation/proc/flush_queue()
	for(var/turf/T as anything in queued_waves)
		var/list/L = queued_waves[T]
		for(var/datum/radiation_burst/B as anything in L)
			new /datum/radiation_pulse(T, B.intensity, B.falloff, B.highest, B.emitter_count)
	queued_waves.len = 0

/datum/controller/subsystem/radiation/proc/queue_wave(turf/source, intensity, falloff, can_contaminate)
	// if not contaminating we immediately release, pointless to keep going
	if(!can_contaminate)
		new /datum/radiation_pulse(source, intensity, falloff, can_contaminate = FALSE)
	var/list/datum/radiation_burst/queue = queued_waves[source]
	if(!queue)
		queue = list()
		queued_waves[source] = queue
	for(var/datum/radiation_burst/B as anything in queue)
		if(B.falloff == falloff)
			B.intensity += intensity
			if(intensity > RAD_MOB_ACT_PROTECTION_PER_WAVE_SOURCE)
				++B.emitter_count
			B.highest = max(B.highest, intensity)
			return
	queue += new /datum/radiation_burst(intensity, falloff)

/**
 * todo: comment
 */
/datum/controller/subsystem/radiation/proc/radiation_pulse(atom/source, intensity, falloff_modifier, log, can_contaminate)
	if(!can_fire)	// we don't care
		return FALSE
	var/atom/nested = source
	if(!nested.loc)
		// we're not going to emit in nullspace at all, don't bother
		return
	var/waves = TRUE
	var/turf/T
	if(!isturf(nested))
		do
			nested = nested.loc
			if(nested.rad_flags & RAD_BLOCK_CONTENTS)
				waves = FALSE
				break
		while(nested.loc && !isarea(nested.loc))
		T = get_turf(nested)
	else
		T = nested
	if(waves && T)
		queue_wave(T, intensity, falloff_modifier, can_contaminate)
		var/static/last_huge_pulse = 0
		if(intensity > 1000 && world.time > last_huge_pulse + 10 SECONDS)
			last_huge_pulse = world.time
			log = TRUE
	else
		var/list/things = get_rad_contents(nested)
		for(var/atom/A as anything in things)
			A.rad_act(intensity)
	if(log)
		log_game("Pulse intensity [intensity] falloff [falloff_modifier] in [AREACOORD(T)][waves? "" : " (contained by [nested])"]")
	return TRUE

/**
 * does our best faith attempt at irradiating a whole zlevel without lagging the server to death
 */
/datum/controller/subsystem/radiation/proc/z_radiation(turf/T, z, intensity, falloff_modifier, log, can_contaminate, z_radiate_flags)
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
				var/dist = max(1, get_dist(A, T) * falloff_modifier)
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
				var/dist = max(1, get_dist(A, T) * falloff_modifier)
				A.z_rad_act(INVERSE_SQUARE(intensity, dist, 1))
		else
			for(var/atom/A as anything in z_listeners[z])
				A.z_rad_act(intensity)
