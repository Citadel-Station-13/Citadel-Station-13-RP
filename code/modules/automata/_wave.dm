/**
 * wave effects
 */
/datum/automata/wave
	/// type of spread
	var/wave_spread = WAVE_SPREAD_MINIMAL
	/// current dirs
	var/list/current_dirs = list()
	/// current powers

	/// next

/datum/automata/wave/setup_auto(turf/T, data)
	switch(wave_spread)
		if(WAVE_SPREAD_MINIMAL)

		if(WAVE_SPREAD_SHADOW_LIKE)

		if(WAVE_SPREAD_SHOCKWAVE)


/datum/automata/wave/tick()
	switch(wave_spread)
		if(WAVE_SPREAD_MINIMAL)

		if(WAVE_SPREAD_SHADOW_LIKE)

		if(WAVE_SPREAD_SHOCKWAVE)

	return ..()

