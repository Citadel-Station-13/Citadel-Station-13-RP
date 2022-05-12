/**
 * wave effects
 */
/datum/automata/wave
	/// type of spread
	VAR_PROTECTED/wave_spread = WAVE_SPREAD_MINIMAL
	/// last turfs, assoc list to true for fast hash lookup. makes sure we don't fold in on ourselves.
	VAR_PRIVATE/list/last
	/// current edges associated to directions
	VAR_PRIVATE/list/edges
	/// current edges associated to powers
	VAR_PRIVATE/list/powers
	/// initial power
	var/power_initial
	/// power at which the automata stops
	var/power_considered_dead = WAVE_AUTOMATA_POWER_DEAD

/datum/automata/wave/setup_auto(turf/T, power, dirs)
	power_initial = power
	last = list()
	edges = list()
	powers = list()
	switch(wave_spread)
		if(WAVE_SPREAD_MINIMAL)
			// no preprocessing at all
			edges[T] = ALL_DIRECTION_BITS
			powers[T] = power
		if(WAVE_SPREAD_SHADOW_LIKE)
			edges[T] = dirs? (dirs &= ~(DIAGONAL_DIRECTION_BITS)) : CARDINAL_DIRECTION_BITS
			powers[T] = power
		if(WAVE_SPREAD_SHOCKWAVE)
			// no directionals
			edges[T] = CARDINAL_DIRECTION_BITS
			powers[T] = power
		else
			CRASH("Invalid wave spread [wave_spread].")

/datum/automata/wave/tick()
	// cache for sanic speed
	var/list/turf/edges = src.edges
	var/list/turf/powers = src.powers
	var/list/turf/last = src.last
	// current vars - turf, power, dir
	var/turf/_T
	var/_P
	var/_D
	// next edges, powers
	var/list/turf/edges_next = list()
	var/list/turf/powers_next = list()
	// current vars - returned
	var/_ret
	// current vars - expansions
	var/turf/_expand
	var/_ND

	switch(wave_spread)
		if(WAVE_SPREAD_MINIMAL)
			// minimal - very little simulation, just go
			// we act on current turf in edges
			// we don't use dir bits here
			for(var/i in 1 to edges.len)
				_T = edges[i]
				if(!_T)
					continue
				_P = powers[_T]
				_D = edges[_T]
				_ret = act(_T, _D, _P)
				if(_ret < power_considered_dead)
					continue
#define SIMPLE_EXPAND(T, D, P)	_expand = get_step(T, D); edges_next[_expand] = D; powers_next[_expand] = P;
				if(_D == ALL_DIRECTION_BITS)	// this only happens on first step
					SIMPLE_EXPAND(_T, NORTH, _ret)
					SIMPLE_EXPAND(_T, SOUTH, _ret)
					SIMPLE_EXPAND(_T, EAST, _ret)
					SIMPLE_EXPAND(_T, WEST, _ret)
					SIMPLE_EXPAND(_T, NORTHEAST, _ret)
					SIMPLE_EXPAND(_T, NORTHWEST, _ret)
					SIMPLE_EXPAND(_T, SOUTHEAST, _ret)
					SIMPLE_EXPAND(_T, SOUTHWEST, _ret)
					continue
				// at this point there should only be one dir so...
					SIMPLE_EXPAND(_T, _D, _ret)
				// check diagonal
				if(ISDIAGONALDIR(_D))
					// if so, expand 3 dirs instead of 1
					_ND = turn(_D, 45)
					SIMPLE_EXPAND(_T, _ND, _ret)
					_ND = turn(_D, -45)
					SIMPLE_EXPAND(_T, _ND, _ret)
#undef SIMPLE_EXPAND
		if(WAVE_SPREAD_SHADOW_LIKE)

		if(WAVE_SPREAD_SHOCKWAVE)

	// if next if empty...
	if(!edges_next.len)
		kill()
	else
		// continue
		// shift everything down
		last = edges
		edges = edges_next
		powers = powers_next
	return ..()

/datum/automata/wave/kill()
	. = ..()
	last = edges = powers = null

/**
 * acts on a turf
 * returns new power.
 * dirs are byond directions
 */
/datum/automata/wave/proc/act(turf/T, dirs, power)
	return max(power - 1, 0)

/**
 * debugging wave automata - displays powers.
 */
/datum/automata/wave/debug
	/// impacted turfs
	var/list/turf/impacted = list()

/datum/automata/wave/debug/Destroy()
	clear_impacted()
	return ..()

/datum/automata/wave/debug/proc/clear_impacted()
	for(var/turf/T in impacted)
		T.maptext = null
	impacted = list()

/datum/automata/wave/debug/act(turf/T, dirs, power)
	. = ..()
	T.maptext = "[power]"
