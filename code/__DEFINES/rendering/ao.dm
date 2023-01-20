/**
 *! SSao
 */

#define WALL_AO_ALPHA 80
#define Z_AO_ALPHA 160

#define AO_UPDATE_NONE    0
#define AO_UPDATE_OVERLAY 1
#define AO_UPDATE_REBUILD 2

// If ao_neighbors equals this, no AO shadows are present.
#define AO_ALL_NEIGHBORS 255

/**
 * Define for getting a bitfield of adjacent turfs that meet a condition.
 *  ORIGIN is the object to step from, VAR is the var to write the bitfield to
 *  TVAR is the temporary turf variable to use, TCHECK is the condition to check.
 *  TCHECK generally should reference TVAR.
 *  example:
 * 	var/turf/T
 * 	var/result = 0
 * 	CALCULATE_NEIGHBORS(src, result, T, isopenturf(T))
 */
#define CALCULATE_NEIGHBORS(ORIGIN, VAR, TVAR, TCHECK) \
	for (var/_tdir in GLOB.cardinal) {                 \
		TVAR = get_step(ORIGIN, _tdir);                \
		if ((TVAR) && (TCHECK)) {                      \
			VAR |= _tdir;                              \
		}                                              \
	}                                                  \
	if (VAR & NORTH_JUNCTION) {                        \
		if (VAR & WEST_JUNCTION) {                     \
			TVAR = get_step(ORIGIN, NORTHWEST);        \
			if (TCHECK) {                              \
				VAR |= NORTHWEST_JUNCTION;             \
			}                                          \
		}                                              \
		if (VAR & EAST_JUNCTION) {                     \
			TVAR = get_step(ORIGIN, NORTHEAST);        \
			if (TCHECK) {                              \
				VAR |= NORTHEAST_JUNCTION;             \
			}                                          \
		}                                              \
	}                                                  \
	if (VAR & SOUTH_JUNCTION) {                        \
		if (VAR & WEST_JUNCTION) {                     \
			TVAR = get_step(ORIGIN, SOUTHWEST);        \
			if (TCHECK) {                              \
				VAR |= SOUTHWEST_JUNCTION;             \
			}                                          \
		}                                              \
		if (VAR & EAST_JUNCTION) {                     \
			TVAR = get_step(ORIGIN, SOUTHEAST);        \
			if (TCHECK) {                              \
				VAR |= SOUTHEAST_JUNCTION;             \
			}                                          \
		}                                              \
	}
