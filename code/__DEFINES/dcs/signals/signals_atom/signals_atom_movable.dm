/**
 *! ## Atom Movable Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// From base of atom/movable/Moved(): (/atom)
#define COMSIG_MOVABLE_PRE_MOVE "movable_pre_move"
	#define COMPONENT_MOVABLE_BLOCK_PRE_MOVE (1<<0)
/// From base of atom/movable/Moved(): (atom/old_loc, dir, forced, list/old_locs)
#define COMSIG_MOVABLE_MOVED "movable_moved"
/// From base of atom/movable/Cross(): (/atom/movable)
#define COMSIG_MOVABLE_CROSS "movable_cross"
/// From base of atom/movable/Crossed(): (/atom/movable)
#define COMSIG_MOVABLE_CROSSED "movable_crossed"
/// From base of atom/movable/Uncross(): (/atom/movable)
#define COMSIG_MOVABLE_UNCROSS "movable_uncross"
	#define COMPONENT_MOVABLE_BLOCK_UNCROSS 1
/// From base of atom/movable/Uncrossed(): (/atom/movable)
#define COMSIG_MOVABLE_UNCROSSED "movable_uncrossed"
/// From base of atom/movable/Move(): (/atom/movable)
#define COMSIG_MOVABLE_CROSS_OVER "movable_cross_am"
/// From base of atom/movable/Bump(): (/atom)
#define COMSIG_MOVABLE_BUMP "movable_bump"
/// From base of atom/movable/newtonian_move(): (inertia_direction)
////#define COMSIG_MOVABLE_NEWTONIAN_MOVE "movable_newtonian_move"
	////#define COMPONENT_MOVABLE_NEWTONIAN_BLOCK (1<<0)
/// From base of atom/movable/on_changed_z_level(): (old_z, new_z)
#define COMSIG_MOVABLE_Z_CHANGED "movable_ztransit"
/// Called when the movable is placed in an unaccessible area, used for stationloving: ()
////#define COMSIG_MOVABLE_SECLUDED_LOCATION "movable_secluded"
/// From base of atom/movable/Hear(): (proc args list(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list()))
////#define COMSIG_MOVABLE_HEAR "movable_hear"
	////#define HEARING_MESSAGE 1
	////#define HEARING_SPEAKER 2
	////#define HEARING_LANGUAGE 3
	////#define HEARING_RAW_MESSAGE 4
	/* #define HEARING_RADIO_FREQ 5
	#define HEARING_SPANS 6
	#define HEARING_MESSAGE_MODE 7 */

/// Called when the movable is added to a disposal holder object for disposal movement: (obj/structure/disposalholder/holder, obj/machinery/disposal/source)
////#define COMSIG_MOVABLE_DISPOSING "movable_disposing"
/// Called when movable is expelled from a disposal pipe, bin or outlet on obj/pipe_eject: (direction)
////#define COMSIG_MOVABLE_PIPE_EJECTING "movable_pipe_ejecting"
/// Called when the movable sucessfully has it's anchored var changed, from base atom/movable/set_anchored(): (value)
#define COMSIG_MOVABLE_SET_ANCHORED "movable_set_anchored"
/// From base of atom/movable/setGrabState(): (newstate)
////#define COMSIG_MOVABLE_SET_GRAB_STATE "living_set_grab_state"
/// Called when the movable tries to change its dynamic light color setting, from base atom/movable/lighting_overlay_set_color(): (color)
////#define COMSIG_MOVABLE_LIGHT_OVERLAY_SET_RANGE "movable_light_overlay_set_color"
/// Called when the movable tries to change its dynamic light power setting, from base atom/movable/lighting_overlay_set_power(): (power)
////#define COMSIG_MOVABLE_LIGHT_OVERLAY_SET_POWER "movable_light_overlay_set_power"
/// Called when the movable tries to change its dynamic light range setting, from base atom/movable/lighting_overlay_set_range(): (range)
////#define COMSIG_MOVABLE_LIGHT_OVERLAY_SET_COLOR "movable_light_overlay_set_range"
/// Called when the movable tries to toggle its dynamic light LIGHTING_ON status, from base atom/movable/lighting_overlay_toggle_on(): (new_state)
////#define COMSIG_MOVABLE_LIGHT_OVERLAY_TOGGLE_ON "movable_light_overlay_toggle_on"
/// Called when the movable's glide size is updated: (new_glide_size)
#define COMSIG_MOVABLE_UPDATE_GLIDE_SIZE "movable_glide_size"
/// Called when a movable is hit by a plunger in layer mode, from /obj/item/plunger/attack_atom()
////#define COMSIG_MOVABLE_CHANGE_DUCT_LAYER "movable_change_duct_layer"
/// Called when a movable is teleported from `do_teleport()`: (destination, channel)
////#define COMSIG_MOVABLE_TELEPORTED "movable_teleported"
/// From base of atom/movable/Process_Spacemove(): (movement_dir)
////#define COMSIG_MOVABLE_SPACEMOVE "spacemove"
	////#define COMSIG_MOVABLE_STOP_SPACEMOVE (1<<0)
/// called when we have a drastic pixel x/y change and things should update
#define COMSIG_MOVABLE_PIXEL_OFFSET_CHANGED "pixel_offset_changed"
