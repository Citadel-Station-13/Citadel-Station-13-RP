/**
 *! ## Organ Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// Called on the organ when it is removed from someone (mob/living/carbon/old_owner)
// todo: this doesn't work
#define COMSIG_ORGAN_REMOVED "comsig_organ_remove"
