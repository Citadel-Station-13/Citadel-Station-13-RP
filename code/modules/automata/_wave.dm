/**
 * wave effects
 */
/datum/automata/wave
	/// type of spread
	var/wave_spread = WAVE_SPREAD_MINIMAL
	/// last turfs, assoc list to true for fast hash lookup. makes sure we don't fold in on ourselves.
	VAR_PRIVATE/list/last
	/// current edges = dirs
	VAR_PRIVATE/list/edges
	/// current powers
	VAR_PRIVATE/list/powers
	/// initial power
	var/power_initial
	/// power at which the automata stops
	var/power_considered_dead = WAVE_AUTOMATA_POWER_DEAD

/datum/automata/wave/setup_auto(turf/T, power, dir)
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
			edges[T] = dir? dir : ALL_DIRECTION_BITS
			powers[T] = power
		if(WAVE_SPREAD_SHOCKWAVE)
			// no directionals. we use cardinal bits, though, due to the algorithm.
			edges[T] = NORTH|SOUTH|EAST|WEST
			powers[T] = power
		else
			CRASH("Invalid wave spread [wave_spread].")

/datum/automata/wave/tick()
	// remove old acting
	cleanup_turfs_acting()
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
	// current vars - track returned per turf too
	var/list/turf/returned = list()

// usually i wouldn't bother documenting forbidden defines but
// just incase someone needs to debug/read later
/**
 * base run for current turf
 */
#define ITERATION_BASE							\
	_T = edges[i];								\
	if(!_T) {									\
		continue;								\
	};											\
	_P = powers[_T];							\
	_D = edges[_T];								\
	_ret = act(_T, _D, _P);						\
	returned[_T] = _ret;						\
	if(_ret < power_considered_dead){			\
		continue;								\
	}
// FOR MINIMAL
/**
 * simple expand: really simple, take dir, set next turf in edges next, set power, etc
 *
 * params:
 * T - turf to expand from
 * D - dir to expand in
 * P - power to set expanded turf to
 */
#define SIMPLE_EXPAND(T, D, P)	_expand = get_step(T, D); edges_next[_expand] = D; powers_next[_expand] = P;
// FOR SHADOWCAST
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
// FOR SHOCKWAVE
/**
 * runs a specific cardinal
 */
#define SHOCKWAVE_MARK_CARDINAL(T, P, D, ED)								\
	if(D & ED){																\
		_expand = get_step(T, ED);											\
		if(!(last[_expand] || edges[_expand])){								\
			edges_next[_expand] |= ED;										\
			powers_next[_expand] = max(powers_next[_expand], P);			\
		}																	\
	}

/**
 * runs a specific cardinal on diagstep
 */
#define SHOCKWAVE_MARK_DIAGONAL_SUBSTEP(T, P, D, ED)	SHOCKWAVE_MARK_CARDINAL(T, P, D, ED)

/**
 * iteration base for diagonals, basically modified ITERATION_BASE
 */
#define ITERATION_BASE_DIAGONAL					\
	_P = diagonal_powers[_T];					\
	_D = diagonals[_T];							\
	_ret = act(_T, _D, _P);						\
	returned[_T] = _ret;						\
	if(_ret < power_considered_dead){			\
		continue;								\
	}

/**
 * iteration base for marking diagonals
 */
#define ITERATION_BASE_DIAGMARK					\
	_T = edges[i];								\
	if(!_T){									\
		continue;								\
	};											\
	_D = edges[_T];								\
	_P = powers[_T];							\
	_ret = returned[_T];						\
	if(_ret < power_considered_dead){			\
		continue;								\
	};

/**
 * diagonal marking internal substep
 */
#define SHOCKWAVE_DIAGONAL_MARK_SUBSTEP(T, D, ED, OP, RP)								\
	_expand = get_step(T, ED);															\
	if(!last[_expand] && !edges[_expand]){												\
		if(!edges_next[_expand]){														\
			diagonals[_expand] |= ED;													\
			diagonal_powers[_expand] = min(diagonal_powers[_expand] + RP, OP);			\
		};																				\
		else {																			\
			powers_next[_expand] = max(powers_next[_expand], RP);						\
		};																				\
	};
/**
 * marking diagonals: turfs considered for an immediate, quick expansion due to being perpendicular to normal expansions
 *
 * to explain the dumb math:
 * turn() has cost
 * bit ops on constants with constants don't
 * first one is clockwise
 * second one counterclockwise
 * figure it out ;)
 */
#define SHOCKWAVE_DIAGONAL_MARK(T, D, ED, OP, RP)																								\
	if(D & ED){																																	\
		SHOCKWAVE_DIAGONAL_MARK_SUBSTEP(T, D, (((ED & NORTH) << 2) | ((ED & SOUTH) << 2) | ((ED & EAST) >> 1) | ((ED & WEST) >> 3)), OP, RP);	\
		SHOCKWAVE_DIAGONAL_MARK_SUBSTEP(T, D, (((ED & NORTH) << 3) | ((ED & SOUTH) << 1) | ((ED & EAST) >> 2) | ((ED & WEST) >> 2)), OP, RP);	\
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
					ITERATION_BASE
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
					ITERATION_BASE
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
					ITERATION_BASE
					SHADOWCAST_INIT(_T, _ret, _D, NORTH_BIT, NORTH, CONICAL_NORTH_BITS)
					SHADOWCAST_INIT(_T, _ret, _D, NORTHEAST_BIT, NORTHEAST, NORTHEAST_BIT)
					SHADOWCAST_INIT(_T, _ret, _D, NORTHWEST_BIT, NORTHWEST, NORTHWEST_BIT)
					SHADOWCAST_INIT(_T, _ret, _D, SOUTH_BIT, SOUTH, CONICAL_SOUTH_BITS)
					SHADOWCAST_INIT(_T, _ret, _D, SOUTHEAST_BIT, SOUTHEAST, SOUTHEAST_BIT)
					SHADOWCAST_INIT(_T, _ret, _D, SOUTHWEST_BIT, SOUTHWEST, SOUTHWEST_BIT)
					SHADOWCAST_INIT(_T, _ret, _D, WEST_BIT, WEST, CONICAL_WEST_BITS)
					SHADOWCAST_INIT(_T, _ret, _D, EAST_BIT, EAST, CONICAL_EAST_BITS)
			else
				// other steps do full sim
				for(var/i in 1 to edges.len)
					ITERATION_BASE
					SHADOWCAST(_T, _ret, _D, NORTH_BIT, NORTH)
					SHADOWCAST(_T, _ret, _D, EAST_BIT, EAST)
					SHADOWCAST(_T, _ret, _D, WEST_BIT, WEST)
					SHADOWCAST(_T, _ret, _D, SOUTH_BIT, SOUTH)
					SHADOWCAST(_T, _ret, _D, NORTHEAST_BIT, NORTHEAST)
					SHADOWCAST(_T, _ret, _D, NORTHWEST_BIT, NORTHWEST)
					SHADOWCAST(_T, _ret, _D, SOUTHEAST_BIT, SOUTHEAST)
					SHADOWCAST(_T, _ret, _D, SOUTHWEST_BIT, SOUTHWEST)

		if(WAVE_SPREAD_SHOCKWAVE)
			// this is annoying
			// to simulate diagonals we do a cardinal tick
			// and gather the diagonals using turn's at 90 degrees
			// and then tick the diagonals in a second processing step

			// we will check last here to prevent folding on a previous wave,
			// also set up diags list
			var/list/turf/diagonals = list()
			var/list/turf/diagonal_powers = list()

			// first, process all edges cardinally
			for(var/i in 1 to edges.len)
				ITERATION_BASE
				SHOCKWAVE_MARK_CARDINAL(_T, _ret, _D, NORTH)
				SHOCKWAVE_MARK_CARDINAL(_T, _ret, _D, SOUTH)
				SHOCKWAVE_MARK_CARDINAL(_T, _ret, _D, EAST)
				SHOCKWAVE_MARK_CARDINAL(_T, _ret, _D, WEST)
			// then mark all diagonals. we need to do this after edges to prevent order of processing nondeterminism
			for(var/i in 1 to edges.len)
				ITERATION_BASE_DIAGMARK
				SHOCKWAVE_DIAGONAL_MARK(_T, _D, NORTH, _P, _ret)
				SHOCKWAVE_DIAGONAL_MARK(_T, _D, SOUTH, _P, _ret)
				SHOCKWAVE_DIAGONAL_MARK(_T, _D, EAST, _P, _ret)
				SHOCKWAVE_DIAGONAL_MARK(_T, _D, WEST, _P, _ret)
			// then, process diagonals
			// make sure diagonals are added to edges so they're part of the last[] and edges[] exclusion
			edges += diagonals
			for(_T in diagonals)
				ITERATION_BASE_DIAGONAL
				SHOCKWAVE_MARK_DIAGONAL_SUBSTEP(_T, _ret, _D, NORTH)
				SHOCKWAVE_MARK_DIAGONAL_SUBSTEP(_T, _ret, _D, SOUTH)
				SHOCKWAVE_MARK_DIAGONAL_SUBSTEP(_T, _ret, _D, EAST)
				SHOCKWAVE_MARK_DIAGONAL_SUBSTEP(_T, _ret, _D, WEST)
			// but also remove them from edges next and powers next because we're done exploding them
			edges_next -= diagonals
			powers_next -= diagonals

#undef ITERATION_BASE_DIAGMARK
#undef ITERATION_BASE_DIAGONAL
#undef SHOCKWAVE_MARK_CARDINAL
#undef SHOCKWAVE_DIAGONAL_MARK
#undef SHOCKWAVE_MARK_DIAGONAL_SUBSTEP
#undef SHADOWCAST_INIT
#undef SHADOWCAST
#undef SIMPLE_EXPAND
#undef ITERATION_BASE

	// continue
	// shift everything down
	src.last = edges
	src.edges = edges_next
	src.powers = powers_next

	// call base logic
	. = ..()
	// if done..
	if(!edges.len)
		stop(TRUE)

/datum/automata/wave/cleanup()
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
	/// additional dense falloff
	var/dense_falloff = 0

/datum/automata/wave/debug/Destroy()
	clear_impacted()
	if(GLOB.active_wave_automata_test == src)
		GLOB.active_wave_automata_test = null
	return ..()

/datum/automata/wave/debug/proc/clear_impacted()
	for(var/turf/T in impacted)
		T.maptext = null
	impacted = list()

/datum/automata/wave/debug/act(turf/T, dirs, power)
	. = ..()
	if(T.density)
		. -= dense_falloff
	else
		for(var/obj/O in T)
			if(O.density && O.opacity)
				. -= dense_falloff
				break
	T.maptext = "[power]"
	impacted += T

GLOBAL_DATUM(active_wave_automata_test, /datum/automata/wave)

/proc/wave_automata_test(turf/T, type = WAVE_SPREAD_MINIMAL, dense_falloff = 0, power = 50, dirs)
	power = clamp(power, 0, 100)
	var/datum/automata/wave/debug/W = new
	W.wave_spread = type
	if(GLOB.active_wave_automata_test)
		QDEL_NULL(GLOB.active_wave_automata_test)
	GLOB.active_wave_automata_test = W
	W.dense_falloff = dense_falloff
	W.setup_auto(T, power, dirs)
	W.delay = 0.25 SECONDS
	W.start()
	QDEL_IN(W, 30 SECONDS)
