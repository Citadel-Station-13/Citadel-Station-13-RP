/**
 *! ## Globally Accessible Object Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// From SSJob when DivideOccupations is called
////#define COMSIG_OCCUPATIONS_DIVIDED "occupations_divided"

/// From SSsun when the sun changes position : (azimuth)
////#define COMSIG_SUN_MOVED "sun_moved"

/// From SSsecurity_level when the security level changes : (new_level)
////#define COMSIG_SECURITY_LEVEL_CHANGED "security_level_changed"

/// From SSshuttle when the supply shuttle starts spawning orders : ()
////#define COMSIG_SUPPLY_SHUTTLE_BUY "supply_shuttle_buy"
