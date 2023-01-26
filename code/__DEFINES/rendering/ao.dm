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
 * - ORIGIN  - The atom to step from,
 * - VAR     - The var to write the bitfield to.
 * - TVAR   - The temporary turf variable to use.
 * - TFUNC - An additional function used to validate the turf. Generally should reference TVAR.
 *   - Example:
 *   -    var/VAR_INPUT = 0
 *   -    var/turf/TVAR_INPUT
 *   -    CALCULATE_NEIGHBORS(src, VAR_INPUT, TVAR_INPUT, isopenturf(TVAR_INPUT))
 *   -    // isopenturf(TVAR_INPUT) NEEDS to be in the macro call since its nested into for loops.
 */
#define CALCULATE_NEIGHBORS(ORIGIN, VAR, TVAR, TFUNC) \
	for (var/_tdir in GLOB.cardinal) {                \
		TVAR = get_step(ORIGIN, _tdir);               \
		if ((TVAR) && (TFUNC)) {                      \
			VAR |= _tdir;                             \
		}                                             \
	}                                                 \
	if (VAR & NORTH_JUNCTION) {                       \
		if (VAR & WEST_JUNCTION) {                    \
			TVAR = get_step(ORIGIN, NORTHWEST);       \
			if (TFUNC) {                              \
				VAR |= NORTHWEST_JUNCTION;            \
			}                                         \
		}                                             \
		if (VAR & EAST_JUNCTION) {                    \
			TVAR = get_step(ORIGIN, NORTHEAST);       \
			if (TFUNC) {                              \
				VAR |= NORTHEAST_JUNCTION;            \
			}                                         \
		}                                             \
	}                                                 \
	if (VAR & SOUTH_JUNCTION) {                       \
		if (VAR & WEST_JUNCTION) {                    \
			TVAR = get_step(ORIGIN, SOUTHWEST);       \
			if (TFUNC) {                              \
				VAR |= SOUTHWEST_JUNCTION;            \
			}                                         \
		}                                             \
		if (VAR & EAST_JUNCTION) {                    \
			TVAR = get_step(ORIGIN, SOUTHEAST);       \
			if (TFUNC) {                              \
				VAR |= SOUTHEAST_JUNCTION;            \
			}                                         \
		}                                             \
	}
