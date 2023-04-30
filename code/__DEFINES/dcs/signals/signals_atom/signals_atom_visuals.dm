/**
 *! ## Atom Signals - Visuals / VFX. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// generally called before temporary non-parallel animate()s on the atom (animation_duration)
#define COMSIG_ATOM_TEMPORARY_ANIMATION_START "atom_temp_animate_start"
