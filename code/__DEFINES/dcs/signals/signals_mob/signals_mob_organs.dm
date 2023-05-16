/**
 *! ## Organ Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// Called on the organ when it is implanted into someone (mob/living/carbon/receiver)
////#define COMSIG_ORGAN_IMPLANTED "comsig_organ_implanted"
/// Called on the organ when it is removed from someone (mob/living/carbon/old_owner)
#define COMSIG_ORGAN_REMOVED "comsig_organ_remove"
/// From /item/organ/proc/Insert() (/obj/item/organ/)
////#define COMSIG_CARBON_GAIN_ORGAN "carbon_gain_organ"
/// From /item/organ/proc/Remove() (/obj/item/organ/)
////#define COMSIG_CARBON_LOSE_ORGAN "carbon_lose_organ"
