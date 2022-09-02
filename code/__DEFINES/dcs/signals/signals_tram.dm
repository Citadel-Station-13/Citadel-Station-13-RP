/**
 *! ## Tram Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// Sent from /obj/structure/industrial_lift/tram when its travelling status updates. (travelling)
////#define COMSIG_TRAM_SET_TRAVELLING "tram_set_travelling"

/// Sent from /obj/structure/industrial_lift/tram when it begins to travel. (obj/landmark/tram/from_where, obj/landmark/tram/to_where)
////#define COMSIG_TRAM_TRAVEL "tram_travel"
