/**
 *! ## Object Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// From /obj/machinery/computer/arcade/prizevend(mob/user, prizes = 1)
#define COMSIG_ARCADE_PRIZEVEND "arcade_prizevend"

/// Called on implants, after an implant has been removed: (mob/living/source, silent, special)
// todo: this doesn't work, and probably shouldn't be here!
#define COMSIG_IMPLANT_REMOVED "implant_removed"

// todo: these two shouldn't be here
#define COMSIG_ITEM_ATTACK "item_attack"
