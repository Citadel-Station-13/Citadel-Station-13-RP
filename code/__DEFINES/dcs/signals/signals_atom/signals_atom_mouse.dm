/**
 *! ## Mouse Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

#warn click signal

/// From base of atom/OnMouseDrop(): (/atom/over, /mob/user, proximity, params)
#define COMSIG_MOUSEDROP_ONTO "mousedrop_onto"
/// From base of atom/MouseDroppedOn(): (/atom/from, /mob/user, proximity, params)
#define COMSIG_MOUSEDROPPED_ONTO "mousedropped_onto"
	/// blocks standard mousedrop procs from running, works on both, will terminate remainder of mousedrop proc chain
	#define COMPONENT_NO_MOUSEDROP (1<<0)
/// From base of mob/MouseWheelOn(): (/atom, delta_x, delta_y, params)
#define COMSIG_MOUSE_SCROLL_ON "mousescroll_on"
