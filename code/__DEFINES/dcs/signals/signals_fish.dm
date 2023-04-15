/**
 *! ## Fishing Module Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

// Aquarium related signals
#define COMSIG_AQUARIUM_SURFACE_CHANGED "aquarium_surface_changed"
#define COMSIG_AQUARIUM_FLUID_CHANGED "aquarium_fluid_changed"
/// Fishing challenge completed
#define COMSIG_FISHING_CHALLENGE_COMPLETED "fishing_completed"

//? Rods

/// Sent by the target when you try to use a fishing rod on anything: (obj/item/fishing_rod/rod, mob/user)
#define COMSIG_PRE_FISHING_QUERY "pre_fishing_query"

/// Sent by the target when a fishing rod is used on it.
#define COMSIG_FISHING_ROD_CAST "fishing_rod_cast"
	#define FISHING_ROD_CAST_HANDLED (1<<0)

/// Sent by the fishing line /datum/beam when fishing line is snapped
#define COMSIG_FISHING_LINE_SNAPPED "fishing_line_interrupted"

//? Fish

/// Sent by the fish when its status changes
#define COMSIG_FISH_STATUS_CHANGED "fish_status_changed"
/// Sent by the fish when it's stirred / disturbed
#define COMSIG_FISH_STIRRED "fish_stirred"
