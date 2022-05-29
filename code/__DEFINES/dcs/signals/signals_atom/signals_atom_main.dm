/**
 *! ## Main Atom Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

//! ## /atom Signals.
/// From base of atom/proc/Initialize(): sent any time a new atom is created in this atom
#define COMSIG_ATOM_INITIALIZED_ON "atom_initialized_on"
/// From SSatoms InitAtom - Only if the  atom was not deleted or failed initialization
#define COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZE "atom_init_success"
/// From base of atom/examine(): (/mob, list/examine_text)
#define COMSIG_PARENT_EXAMINE "atom_examine"
/// From base of atom/get_examine_name(): (/mob, list/overrides)
#define COMSIG_ATOM_GET_EXAMINE_NAME "atom_examine_name"
/// From base of atom/examine_more(): (/mob)
#define COMSIG_PARENT_EXAMINE_MORE "atom_examine_more"
	//*Positions for overrides list
	#define EXAMINE_POSITION_ARTICLE (1<<0)
	#define EXAMINE_POSITION_BEFORE (1<<1)
	//*End positions
	#define COMPONENT_EXNAME_CHANGED (1<<0)
/// From base of [/atom/proc/update_appearance]: (updates)
#define COMSIG_ATOM_UPDATE_APPEARANCE "atom_update_appearance"
	/// If returned from [COMSIG_ATOM_UPDATE_APPEARANCE] it prevents the atom from updating its name.
	////#define COMSIG_ATOM_NO_UPDATE_NAME UPDATE_NAME
	/// If returned from [COMSIG_ATOM_UPDATE_APPEARANCE] it prevents the atom from updating its desc.
	////#define COMSIG_ATOM_NO_UPDATE_DESC UPDATE_DESC
	/// If returned from [COMSIG_ATOM_UPDATE_APPEARANCE] it prevents the atom from updating its icon.
	////#define COMSIG_ATOM_NO_UPDATE_ICON UPDATE_ICON
/// From base of [/atom/proc/update_name]: (updates)
#define COMSIG_ATOM_UPDATE_NAME "atom_update_name"
/// From base of [/atom/proc/update_desc]: (updates)
#define COMSIG_ATOM_UPDATE_DESC "atom_update_desc"
/// From base of [/atom/update_icon]: ()
#define COMSIG_ATOM_UPDATE_ICON "atom_update_icon"
	///? If returned from [COMSIG_ATOM_UPDATE_ICON] it prevents the atom from updating its icon state.
	////#define COMSIG_ATOM_NO_UPDATE_ICON_STATE UPDATE_ICON_STATE
	///? If returned from [COMSIG_ATOM_UPDATE_ICON] it prevents the atom from updating its overlays.
	////#define COMSIG_ATOM_NO_UPDATE_OVERLAYS UPDATE_OVERLAYS
/// From base of [atom/update_icon_state]: ()
#define COMSIG_ATOM_UPDATE_ICON_STATE "atom_update_icon_state"
/// From base of [/atom/update_overlays]: (list/new_overlays)
#define COMSIG_ATOM_UPDATE_OVERLAYS "atom_update_overlays"
/// From base of [/atom/update_icon]: (signalOut, did_anything)
#define COMSIG_ATOM_UPDATED_ICON "atom_updated_icon"
/// From base of [/atom/proc/smooth_icon]: ()
#define COMSIG_ATOM_SMOOTHED_ICON "atom_smoothed_icon"
/// From base of atom/Entered(): (atom/movable/arrived, atom/old_loc, list/atom/old_locs)
#define COMSIG_ATOM_ENTERED "atom_entered"
/// Sent from the atom that just Entered src. From base of atom/Entered(): (/atom/destination, atom/old_loc, list/atom/old_locs)
////#define COMSIG_ATOM_ENTERING "atom_entering"
/// From base of atom/Exit(): (/atom/movable/leaving, direction)
#define COMSIG_ATOM_EXIT "atom_exit"
	#define COMPONENT_ATOM_BLOCK_EXIT (1<<0)
/// From base of atom/Exited(): (atom/movable/gone, direction)
#define COMSIG_ATOM_EXITED "atom_exited"
/// From base of atom/Bumped(): (/atom/movable)
#define COMSIG_ATOM_BUMPED "atom_bumped"
/// From base of atom/handle_atom_del(): (atom/deleted)
////#define COMSIG_ATOM_CONTENTS_DEL "atom_contents_del"
/// From base of atom/has_gravity(): (turf/location, list/forced_gravities)
////#define COMSIG_ATOM_HAS_GRAVITY "atom_has_gravity"
/// From internal loop in atom/movable/proc/CanReach(): (list/next)
////#define COMSIG_ATOM_CANREACH "atom_can_reach"
	////#define COMPONENT_ALLOW_REACH (1<<0)
	////#define COMPONENT_BLOCK_REACH (1<<1)
/// For when an atom has been created through processing (atom/original_atom, list/chosen_processing_option)
////#define COMSIG_ATOM_CREATEDBY_PROCESSING "atom_createdby_processing"
/// When an atom is processed (mob/living/user, obj/item/I, list/atom/results)
////#define COMSIG_ATOM_PROCESSED "atom_processed"
/// Called when teleporting into a protected turf: (channel, turf/origin)
////#define COMSIG_ATOM_INTERCEPT_TELEPORT "intercept_teleport"
	////#define COMPONENT_BLOCK_TELEPORT (1<<0)
/// Called when an atom is added to the hearers on get_hearers_in_view(): (list/processing_list, list/hearers)
#define COMSIG_ATOM_HEARER_IN_VIEW "atom_hearer_in_view"
/// Called when an atom starts orbiting another atom: (atom/movable/orbiter, radius, clockwise, rotation_speed, rotation_segments, pre_rotation)
#define COMSIG_ATOM_ORBIT_BEGIN "atom_orbit_begin"
/// Called from orbit component: (atom/movable/orbiter, refreshing)
#define COMSIG_ATOM_ORBIT_END "atom_orbit_end"
/// Called when an atom stops orbiting another atom: (atom)
////#define COMSIG_ATOM_ORBIT_STOP "atom_orbit_stop"
/// From base of atom/set_opacity(): (new_opacity)
////#define COMSIG_ATOM_SET_OPACITY "atom_set_opacity"
/// From base of atom/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
////#define COMSIG_ATOM_HITBY "atom_hitby"
/// When an atom starts playing a song datum (datum/song)
////#define COMSIG_ATOM_STARTING_INSTRUMENT "atom_starting_instrument"

/// When the transform or an atom is varedited through vv topic.
////#define COMSIG_ATOM_VV_MODIFY_TRANSFORM "atom_vv_modify_transform"

/// Generally called before temporary non-parallel animate()s on the atom (animation_duration)
////#define COMSIG_ATOM_TEMPORARY_ANIMATION_START "atom_temp_animate_start"
