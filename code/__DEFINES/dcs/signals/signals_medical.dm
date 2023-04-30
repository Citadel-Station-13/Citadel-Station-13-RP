/**
 *! ## Medical Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// From /datum/surgery/New(): (datum/surgery/surgery, surgery_location (body zone), obj/item/bodypart/targeted_limb)
////#define COMSIG_MOB_SURGERY_STARTED "mob_surgery_started"

/// From /datum/surgery_step/success(): (datum/surgery_step/step, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
////#define COMSIG_MOB_SURGERY_STEP_SUCCESS "mob_surgery_step_success"
