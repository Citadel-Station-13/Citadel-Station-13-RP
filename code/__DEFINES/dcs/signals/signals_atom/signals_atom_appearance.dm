/**
 *! ## Atom Appearance Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// From base of [/atom/proc/update_appearance]: (updates)
#define COMSIG_ATOM_UPDATE_APPEARANCE "atom_update_appearance"
	/// If returned from [COMSIG_ATOM_UPDATE_APPEARANCE] it prevents the atom from updating its name.
	////#define COMSIG_ATOM_NO_UPDATE_NAME UPDATE_NAME
	/// If returned from [COMSIG_ATOM_UPDATE_APPEARANCE] it prevents the atom from updating its desc.
	////#define COMSIG_ATOM_NO_UPDATE_DESC UPDATE_DESC
	/// If returned from [COMSIG_ATOM_UPDATE_APPEARANCE] it prevents the atom from updating its icon.
	////#define COMSIG_ATOM_NO_UPDATE_ICON UPDATE_ICON
/// From base of [/atom/proc/update_name], called after all overrides: (updates)
#define COMSIG_ATOM_UPDATE_NAME "atom_update_name"
/// From base of [/atom/proc/update_desc], called after all overrides: (updates)
#define COMSIG_ATOM_UPDATE_DESC "atom_update_desc"
/// From base of [/atom/update_icon]: ()
#define COMSIG_ATOM_UPDATE_ICON "atom_update_icon"
	///? If returned from [COMSIG_ATOM_UPDATE_ICON] it prevents the atom from updating its icon state.
	#define COMSIG_ATOM_NO_UPDATE_ICON_STATE UPDATE_ICON_STATE
	///? If returned from [COMSIG_ATOM_UPDATE_ICON] it prevents the atom from updating its overlays.
	#define COMSIG_ATOM_NO_UPDATE_OVERLAYS UPDATE_OVERLAYS
/// From base of [atom/update_icon_state]: ()
#define COMSIG_ATOM_UPDATE_ICON_STATE "atom_update_icon_state"
/// From base of [/atom/update_overlays]: (list/new_overlays)
#define COMSIG_ATOM_UPDATE_OVERLAYS "atom_update_overlays"
/// From base of [/atom/update_icon]: (signalOut, did_anything)
#define COMSIG_ATOM_UPDATED_ICON "atom_updated_icon"
/// From base of [/atom/proc/smooth_icon]: ()
#define COMSIG_ATOM_SMOOTHED_ICON "atom_smoothed_icon"
