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
 * - T_VAR   - The temporary turf variable to use, T_CHECK is the condition to check.
 * - T_CHECK - An additional function used to validate the turf. Generally should reference T_VAR.
 *   - Example:
 *   -    var/turf/T_VAR_INPUT
 *   -    var/VAR_INPUT = 0
 *   -    CALCULATE_NEIGHBORS(src, VAR_INPUT, T_VAR_INPUT, isopenturf(T_VAR_INPUT))
 */
#define CALCULATE_NEIGHBORS(ORIGIN, VAR, T_VAR, T_CHECK) \
	for (var/_tdir in GLOB.cardinal) {                   \
		T_VAR = get_step(ORIGIN, _tdir);                 \
		if ((T_VAR) && (T_CHECK)) {                      \
			VAR |= _tdir;                                \
		}                                                \
	}                                                    \
	if (VAR & NORTH_JUNCTION) {                          \
		if (VAR & WEST_JUNCTION) {                       \
			T_VAR = get_step(ORIGIN, NORTHWEST);         \
			if (T_CHECK) {                               \
				VAR |= NORTHWEST_JUNCTION;               \
			}                                            \
		}                                                \
		if (VAR & EAST_JUNCTION) {                       \
			T_VAR = get_step(ORIGIN, NORTHEAST);         \
			if (T_CHECK) {                               \
				VAR |= NORTHEAST_JUNCTION;               \
			}                                            \
		}                                                \
	}                                                    \
	if (VAR & SOUTH_JUNCTION) {                          \
		if (VAR & WEST_JUNCTION) {                       \
			T_VAR = get_step(ORIGIN, SOUTHWEST);         \
			if (T_CHECK) {                               \
				VAR |= SOUTHWEST_JUNCTION;               \
			}                                            \
		}                                                \
		if (VAR & EAST_JUNCTION) {                       \
			T_VAR = get_step(ORIGIN, SOUTHEAST);         \
			if (T_CHECK) {                               \
				VAR |= SOUTHEAST_JUNCTION;               \
			}                                            \
		}                                                \
	}
