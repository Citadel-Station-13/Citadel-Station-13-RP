/**
 *! ## Atom Radiation Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

//! STOP. Are you about to add RAD_PROBE?
//! Well, don't. Add a trait system to manage rad_flags & RAD_BLOCK_CONTENTS, because
//! that's all it does, and there's literally no point in sending arg-less signals!
//! If we ever decide to make the signal have an arg, then yes, feel free to. For now, DON'T.

/// From /datum/radiation_wave's iteration: (strength, datum/radiation_wave/wave)
#define COMSIG_ATOM_RAD_PULSE_ITERATE "rad_pulse_iterate"
