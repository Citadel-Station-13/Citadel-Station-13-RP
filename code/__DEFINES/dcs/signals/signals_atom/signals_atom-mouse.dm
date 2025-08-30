/**
 *! ## Mouse Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 *
 * Mouse signals are different from clickchain; these are generally earlier in the chain and are only sent by clients
 * using their, well, mouse. Clickchain is more of a citadel RP concept and is more complicated.
 */

/// Sent with (mob/user, location, control, params).
/// * Do not listen to this signal unless you really know what you're doing. This isn't necessary most of the time.
#define COMSIG_ATOM_CLICK "atom-click"
	/// drops the click. this will stop standard logging too.
	#define RAISE_ATOM_CLICK_DROP (1<<0)

// TODO: audit below

/// From base of atom/OnMouseDrop(): (/atom/over, /mob/user, proximity, params)
#define COMSIG_MOUSEDROP_ONTO "mousedrop_onto"
/// From base of atom/MouseDroppedOn(): (/atom/from, /mob/user, proximity, params)
#define COMSIG_MOUSEDROPPED_ONTO "mousedropped_onto"
	/// blocks standard mousedrop procs from running, works on both, will terminate remainder of mousedrop proc chain
	#define COMPONENT_NO_MOUSEDROP (1<<0)
/// From base of mob/MouseWheelOn(): (/atom, delta_x, delta_y, params)
#define COMSIG_MOUSE_SCROLL_ON "mousescroll_on"
