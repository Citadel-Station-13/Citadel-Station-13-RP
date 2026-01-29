// Subsystem signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

// Point of interest signals
/// Sent from base of /datum/controller/subsystem/points_of_interest/proc/on_poi_element_added : (atom/new_poi)
#define COMSIG_ADDED_POINT_OF_INTEREST "added_point_of_interest"
/// Sent from base of /datum/controller/subsystem/points_of_interest/proc/on_poi_element_removed : (atom/old_poi)
#define COMSIG_REMOVED_POINT_OF_INTEREST "removed_point_of_interest"
