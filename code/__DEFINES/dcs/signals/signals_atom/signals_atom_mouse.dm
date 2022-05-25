/**
 *! ## Mouse Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// From base of client/Click(): (atom/target, atom/location, control, params, mob/user)
#define COMSIG_CLIENT_CLICK "atom_client_click"
/// From base of atom/Click(): (atom/location, control, params, mob/user)
#define COMSIG_CLICK "atom_click"
/// From base of atom/ShiftClick(): (/mob)
#define COMSIG_CLICK_SHIFT "shift_click"
	//? Allows the user to examinate regardless of client.eye.
	////#define COMPONENT_ALLOW_EXAMINATE (1<<0)
/// From base of atom/CtrlClickOn(): (/mob)
#define COMSIG_CLICK_CTRL "ctrl_click"
/// From base of atom/AltClick(): (/mob)
#define COMSIG_CLICK_ALT "alt_click"
	#define COMPONENT_CANCEL_CLICK_ALT (1<<0)
/// From base of atom/alt_click_secondary(): (/mob)
////#define COMSIG_CLICK_ALT_SECONDARY "alt_click_secondary"
	////#define COMPONENT_CANCEL_CLICK_ALT_SECONDARY (1<<0)
/// From base of atom/CtrlShiftClick(/mob)
////#define COMSIG_CLICK_CTRL_SHIFT "ctrl_shift_click"
/// From base of atom/OnMouseDrop(): (/atom/over, /mob/user, proximity, params)
#define COMSIG_MOUSEDROP_ONTO "mousedrop_onto"
/// From base of atom/MouseDroppedOn(): (/atom/from, /mob/user, proximity, params)
#define COMSIG_MOUSEDROPPED_ONTO "mousedropped_onto"
	/// blocks standard mousedrop procs from running, works on both, will terminate remainder of mousedrop proc chain
	#define COMPONENT_NO_MOUSEDROP (1<<0)
/// From base of mob/MouseWheelOn(): (/atom, delta_x, delta_y, params)
#define COMSIG_MOUSE_SCROLL_ON "mousescroll_on"
