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
			// no directionals at all
			// we use byond dir bits
			edges[T] = NORTH|SOUTH|EAST|WEST
			powers[T] = power
		if(WAVE_SPREAD_SHADOW_LIKE)
			// directionals fully allowed
			// we use our own dir bits
			edges[T] = dirs? dirs : ALL_DIRECTION_BITS
			powers[T] = power
		if(WAVE_SPREAD_SHOCKWAVE)
			// no directionals. we use cardinal bits, though, due to the algorithm.
			#warn what bits to use
			edges[T] = NORTH|SOUTH|EAST|WEST
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

// usually i wouldn't bother documenting forbidden defines but
// just incase someone needs to debug/read later
/**
 * simple expand: really simple, take dir, set next turf in edges next, set power, etc
 *
 * params:
 * T - turf to expand from
 * D - dir to expand in
 * P - power to set expanded turf to
 */
#define SIMPLE_EXPAND(T, D, P)	_expand = get_step(T, D); edges_next[_expand] = D; powers_next[_expand] = P;
/**
 * shadowcast helper
 * expands a turf's dirs to edges next
 *
 * params:
 * T, D, P - ditto, thuogh D is direction_BIT and not byond direction defines
 * CD - dir to check.
 * RD - real byond dir, used for the get_step since we use direction bits now
 */
#define SHADOWCAST(T, P, D, CD, RD)										\
	if(D & CD){															\
		_expand = get_step(T, RD);										\
		edges_next[_expand] |= D;										\
		powers_next[_expand] = max(powers_next[_expand], P);			\
	}
/**
 * the above but PD is "put direction", used to direct where the wave goes
 * since on the first step the singular turf has all dirs.
 */
#define SHADOWCAST_INIT(T, P, D, CD, RD, PD)							\
	if(D & CD){															\
		_expand = get_step(T, RD);										\
		edges_next[_expand] |= PD;										\
		powers_next[_expand] = max(powers_next[_expand], P);			\
	}



	switch(wave_spread)
		if(WAVE_SPREAD_MINIMAL)
			// minimal - very little simulation, just go
			// we act on current turf in edges
			// we don't use dir bits here

			// we so not check last list
			// because we ""know"" we're going in a linear circular spread

			// first check first step
			if(iteration == 1)
				// first step just sets up expanding rings
				for(var/i in 1 to edges.len)
					_T = edges[i]
					if(!_T)
						continue
					_P = powers[_T]
					_D = edges[_T]
					_ret = act(_T, _D, _P)
					if(_ret < power_considered_dead)
						continue
					if(_D == ALL_DIRECTION_BITS)
						SIMPLE_EXPAND(_T, NORTH, _ret)
						SIMPLE_EXPAND(_T, SOUTH, _ret)
						SIMPLE_EXPAND(_T, EAST, _ret)
						SIMPLE_EXPAND(_T, WEST, _ret)
						SIMPLE_EXPAND(_T, NORTHEAST, _ret)
						SIMPLE_EXPAND(_T, NORTHWEST, _ret)
						SIMPLE_EXPAND(_T, SOUTHEAST, _ret)
						SIMPLE_EXPAND(_T, SOUTHWEST, _ret)
			else
				// other steps do full sim
				for(var/i in 1 to edges.len)
					_T = edges[i]
					if(!_T)
						continue
					_P = powers[_T]
					_D = edges[_T]
					_ret = act(_T, _D, _P)
					if(_ret < power_considered_dead)
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
		if(WAVE_SPREAD_SHADOW_LIKE)
			// preliminary attempt:
			// propagate cardinals forwards with a cardinal and 45 deg diagonals
			// propagate diagonals forwards with 45 deg cardinals only
			// this prevents corner clipping

			// we do not check last here either because we can't bend around
			// to save some list lookups

			// first check first step
			if(iteration == 1)
				// first step just sets up expanding rings
				for(var/i in 1 to edges.len)
					_T = edges[i]
					if(!_T)
						continue
					_P = powers[_T]
					_D = edges[_T]
					_ret = act(_T, _D, _P)
					if(_ret < power_considered_dead)
						continue
					SHADOWCAST_INIT(_T, _P, _D, NORTH_BIT, NORTH, CONICAL_NORTH_BITS)
					SHADOWCAST_INIT(_T, _P, _D, NORTHEAST_BIT, NORTHEAST, CONICAL_NORTHEAST_BITS)
					SHADOWCAST_INIT(_T, _P, _D, NORTHWEST_BIT, NORTHWEST, CONICAL_NORTHWEST_BITS)
					SHADOWCAST_INIT(_T, _P, _D, SOUTH_BIT, SOUTH, CONICAL_SOUTH_BITS)
					SHADOWCAST_INIT(_T, _P, _D, SOUTHEAST_BIT, SOUTHEAST, CONICAL_SOUTHEAST_BITS)
					SHADOWCAST_INIT(_T, _P, _D, SOUTHWEST_BIT, SOUTHWEST, CONICAL_SOUTHWEST_BITS)
					SHADOWCAST_INIT(_T, _P, _D, WEST_BIT, WEST, CONICAL_WEST_BITS)
					SHADOWCAST_INIT(_T, _P, _D, EAST_BIT, EAST, CONICAL_EAST_BITS)
			else
				// other steps do full sim
				for(var/i in 1 to edges.len)
					_T = edges[i]
					if(!_T)
						continue
					_P = powers[_T]
					_D = edges[_T]
					_ret = act(_T, _D, _P)
					if(_ret < power_considered_dead)
						continue
					SHADOWCAST(_T, _P, _D, NORTH_BIT, NORTH)
					SHADOWCAST(_T, _P, _D, EAST_BIT, EAST)
					SHADOWCAST(_T, _P, _D, WEST_BIT, WEST)
					SHADOWCAST(_T, _P, _D, SOUTH_BIT, SOUTH)
					SHADOWCAST(_T, _P, _D, NORTHEAST_BIT, NORTHEAST)
					SHADOWCAST(_T, _P, _D, NORTHWEST_BIT, NORTHWEST)
					SHADOWCAST(_T, _P, _D, SOUTHEAST_BIT, SOUTHEAST)
					SHADOWCAST(_T, _P, _D, SOUTHWEST_BIT, SOUTHWEST)

		if(WAVE_SPREAD_SHOCKWAVE)
			// this is annoying
			// to simulate diagonals we do a cardinal tick
			// and gather the diagonals using turn's at 90 degrees
			// and then tick the diagonals in a second processing step
			#warn impl




#undef SHADOWCAST_INIT
#undef SHADOWCAST
#undef SIMPLE_EXPAND

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

GLOBAL_DATUM(active_wave_automata_test, /datum/automata/wave)

/proc/wave_automata_test(turf/T, type = WAVE_SPREAD_MINIMAL, power = 50)
	power = clamp(power, 0, 100)
	var/datum/automata/wave/debug/W = new
	if(GLOB.active_wave_automata_test)
		QDEL_NULL(GLOB.active_wave_automata_test)
	GLOB.active_wave_automata_test = W
	W.setup_auto(T, power, dirs)
	W.start()
	QDEL_IN(W, 10 SECONDS)
