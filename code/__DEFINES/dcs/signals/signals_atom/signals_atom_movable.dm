/**
 *! ## Atom Movable Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

//* Movement - Move / Moved *//

/// From base of atom/movable/Moved(): (/atom)
#define COMSIG_MOVABLE_PRE_MOVE "movable_pre_move"
	#define COMPONENT_MOVABLE_BLOCK_PRE_MOVE (1<<0)
/// From base of atom/movable/Moved(): (atom/old_loc, dir, forced, list/old_locs, momentum_change)
#define COMSIG_MOVABLE_MOVED "movable_moved"

//* Movement - Collision *//

// todo: crossers and uncrossers!!!
/// From base of atom/movable/Cross(): (/atom/movable)
#define COMSIG_MOVABLE_CROSS "movable_cross"
/// From base of atom/movable/Crossed(): (/atom/movable)
#define COMSIG_MOVABLE_CROSSED "movable_crossed"
/// From base of atom/movable/Uncross(): (/atom/movable)
#define COMSIG_MOVABLE_UNCROSS "movable_uncross"
	#define COMPONENT_MOVABLE_BLOCK_UNCROSS 1
/// From base of atom/movable/Uncrossed(): (/atom/movable)
#define COMSIG_MOVABLE_UNCROSSED "movable_uncrossed"
/// From base of atom/movable/Bump(): (/atom)
#define COMSIG_MOVABLE_BUMP "movable_bump"

//* Movement - Z Change *//

/// From base of atom/movable/on_changed_z_level(): (old_z, new_z)
#define COMSIG_MOVABLE_Z_CHANGED "movable_ztransit"

//* Movement - Glide Size *//

/// Called when the movable's glide size is updated: (new_glide_size)
#define COMSIG_MOVABLE_UPDATE_GLIDE_SIZE "movable_glide_size"

//* Pixel Offsets *//

/// called when we have a drastic pixel x/y change and things should update
#define COMSIG_MOVABLE_PIXEL_OFFSET_CHANGED "pixel_offset_changed"

//* State Changes *//

/// Called when the movable sucessfully has it's anchored var changed, from base atom/movable/set_anchored(): (value)
#define COMSIG_MOVABLE_SET_ANCHORED "movable_set_anchored"
