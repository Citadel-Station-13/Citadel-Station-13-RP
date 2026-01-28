/**
 *! ## Area Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

//! /area signals
///from base of area/proc/power_change(): ()
#define COMSIG_AREA_POWER_CHANGE "area_power_change"
/// From base of area/Entered(): (atom/movable/arrived, area/old_area)
#define COMSIG_AREA_ENTERED "area_entered"
/// From base of area/Exited(): (atom/movable/gone, direction)
#define COMSIG_AREA_EXITED "area_exited"
