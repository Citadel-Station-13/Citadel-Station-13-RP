/datum/wave_automata_cell
	/// turf
	var/turf/turf
	/// power
	var/power
	/// directions
	var/dir
	/// next
	var/datum/wave_automata_cell/next

/**
 * wave effects
 */
/datum/automata/wave
	/// type of spread
	var/wave_spread = WAVE_SPREAD_MINIMAL
	/// current
	var/list/datum/wave_automata_cell/current
	/// next
	var/list/datum/wave_automata_cell/next

/datum/automata/wave/setup_auto(turf/T, power, dirs)
	switch(wave_spread)
		if(WAVE_SPREAD_MINIMAL)
			// no directionals
			current = new
			current.turf = T
			current.power = power
			current.dir = ALL_DIRECTION_BITS
		if(WAVE_SPREAD_SHADOW_LIKE)
			current = new
			current.turf = T
			current.power = power
			current.dir = dirs? dirs : ALL_DIRECTION_BITS

		if(WAVE_SPREAD_SHOCKWAVE)
			// no directionals
			current = new
			current.turf = T
			current.power = power
			current.dir = ALL_DIRECTION_BITS

/datum/automata/wave/tick()
	// make first node so we don't need to detect nulls later
	var/datum/wave_automata_cell/first = new
	// processing
	var/datum/wave_automata_cell/processing = current
	switch(wave_spread)
		if(WAVE_SPREAD_MINIMAL)

		if(WAVE_SPREAD_SHADOW_LIKE)

		if(WAVE_SPREAD_SHOCKWAVE)

	// if next if empty...
	if(!first.next)
		kill()
	else
		qdel(current)
		// we only even bother qdelling so we know from gc if this gets fucked up
		// we don't qdel every node for this reason, becuase there's only forward references so the chain should follow.
		current = first.next
	return ..()

