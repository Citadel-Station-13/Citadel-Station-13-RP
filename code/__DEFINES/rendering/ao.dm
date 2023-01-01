/**
 *! SSao
 */

#define WALL_AO_ALPHA 80
#define Z_AO_ALPHA 160

#define AO_UPDATE_NONE    0
#define AO_UPDATE_OVERLAY 1
#define AO_UPDATE_REBUILD 2

// If ao_neighbors equals this, no AO shadows are present.
#define AO_ALL_NEIGHBORS 1910

//Redefinitions of the diagonal directions so they can be stored in one var without conflicts
#define N_NORTH     2
#define N_SOUTH     4
#define N_EAST      16
#define N_WEST      256
#define N_NORTHEAST 32
#define N_NORTHWEST 512
#define N_SOUTHEAST 64
#define N_SOUTHWEST 1024

/**
 * Define for getting a bitfield of adjacent turfs that meet a condition.
 *  ORIGIN is the object to step from, VAR is the var to write the bitfield to
 *  TVAR is the temporary turf variable to use, FUNC is the condition to check.
 *  FUNC generally should reference TVAR.
 *  example:
 * 	var/turf/T
 * 	var/result = 0
 * 	CALCULATE_NEIGHBORS(src, result, T, isopenturf(T))
 */
#define CALCULATE_NEIGHBORS(ORIGIN, VAR, TVAR, FUNC) \
	for (var/_tdir in GLOB.cardinal) {               \
		TVAR = get_step(ORIGIN, _tdir);              \
		if ((TVAR) && (FUNC)) {                      \
			VAR |= 1 << _tdir;                       \
		}                                            \
	}                                                \
	if (VAR & N_NORTH) {                             \
		if (VAR & N_WEST) {                          \
			TVAR = get_step(ORIGIN, NORTHWEST);      \
			if (FUNC) {                              \
				VAR |= N_NORTHWEST;                  \
			}                                        \
		}                                            \
		if (VAR & N_EAST) {                          \
			TVAR = get_step(ORIGIN, NORTHEAST);      \
			if (FUNC) {                              \
				VAR |= N_NORTHEAST;                  \
			}                                        \
		}                                            \
	}                                                \
	if (VAR & N_SOUTH) {                             \
		if (VAR & N_WEST) {                          \
			TVAR = get_step(ORIGIN, SOUTHWEST);      \
			if (FUNC) {                              \
				VAR |= N_SOUTHWEST;                  \
			}                                        \
		}                                            \
		if (VAR & N_EAST) {                          \
			TVAR = get_step(ORIGIN, SOUTHEAST);      \
			if (FUNC) {                              \
				VAR |= N_SOUTHEAST;                  \
			}                                        \
		}                                            \
	}
