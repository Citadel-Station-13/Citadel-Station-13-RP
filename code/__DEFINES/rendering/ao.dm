/**
 *! SSao
 */

#define WALL_AO_ALPHA 80
#define Z_AO_ALPHA 160

#define AO_UPDATE_NONE    0
#define AO_UPDATE_OVERLAY 1
#define AO_UPDATE_REBUILD 2

/// If ao_junction equals this, no AO shadows are present.
#define AO_ALL_NEIGHBORS 255

/**
 * Define for getting a bitfield of adjacent turfs that meet a condition.
 *
 * Arguments:
 * - ORIGIN - The atom to step from,
 * - VAR    - The var to write the bitfield to.
 * - TVAR   - The temporary turf variable to use.
 * - FUNC   - An additional function used to validate the turf found in each direction. Generally should reference TVAR.
 *
 * Example:
 * -  var/our_junction = 0
 * -  var/turf/T
 * -  CALCULATE_JUNCTIONS(src, our_junction, T, isopenturf(T))
 * -  // isopenturf(T) NEEDS to be in the macro call since its nested into for loops.
 *
 * NOTICE:
 * - This macro used to be CALCULATE_NEIGHBORS.
 * - It has been renamed to avoid conflicts and confusions with other codebases.
 */
#define CALCULATE_JUNCTIONS(ORIGIN, VAR, TVAR, FUNC) \
	for (var/_tdir in GLOB.cardinal) {               \
		TVAR = get_step(ORIGIN, _tdir);              \
		if ((TVAR) && (FUNC)) {                      \
			VAR |= _tdir;                            \
		}                                            \
	}                                                \
	if (VAR & NORTH_JUNCTION) {                      \
		if (VAR & WEST_JUNCTION) {                   \
			TVAR = get_step(ORIGIN, NORTHWEST);      \
			if (FUNC) {                              \
				VAR |= NORTHWEST_JUNCTION;           \
			}                                        \
		}                                            \
		if (VAR & EAST_JUNCTION) {                   \
			TVAR = get_step(ORIGIN, NORTHEAST);      \
			if (FUNC) {                              \
				VAR |= NORTHEAST_JUNCTION;           \
			}                                        \
		}                                            \
	}                                                \
	if (VAR & SOUTH_JUNCTION) {                      \
		if (VAR & WEST_JUNCTION) {                   \
			TVAR = get_step(ORIGIN, SOUTHWEST);      \
			if (FUNC) {                              \
				VAR |= SOUTHWEST_JUNCTION;           \
			}                                        \
		}                                            \
		if (VAR & EAST_JUNCTION) {                   \
			TVAR = get_step(ORIGIN, SOUTHEAST);      \
			if (FUNC) {                              \
				VAR |= SOUTHEAST_JUNCTION;           \
			}                                        \
		}                                            \
	}
