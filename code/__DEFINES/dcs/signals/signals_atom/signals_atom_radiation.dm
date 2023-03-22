/**
 *! ## Atom Radiation Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

//! STOP. Are you about to add RAD_PROBE?
//! Well, don't. Add a trait system to manage rad_flags & RAD_BLOCK_CONTENTS, because
//! that's all it does, and there's literally no point in sending arg-less signals!
//! If we ever decide to make the signal have an arg, then yes, feel free to. For now, DON'T.

/// From base of datum/radiation_wave_legacy/radiate(): (strength)
#define COMSIG_ATOM_RAD_CONTAMINATING "atom_rad_contam"
	#define COMPONENT_BLOCK_CONTAMINATION (1<<0)
/// From base of datum/radiation_wave_legacy/check_obstructions(): (datum/radiation_wave_legacy, width)
#define COMSIG_ATOM_RAD_WAVE_PASSING "atom_rad_wave_pass"
	#define COMPONENT_RAD_WAVE_HANDLED (1<<0)
