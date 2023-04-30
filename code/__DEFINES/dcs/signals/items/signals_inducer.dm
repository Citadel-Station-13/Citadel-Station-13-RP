/**
 *! ## Inducer Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// From base of /atom/proc/inducer_scan: (obj/item/inducer/I, list/things_to_induce, inducer_flags)
#define COMSIG_INDUCER_SCAN "inducer_check"
	//? Completely block inducer action, no feedback.
	#define COMPONENT_BLOCK_INDUCER (1<<0)
	//? Say something is interfering.
	#define COMPONENT_INTERFERE_INDUCER (1<<1)
	//? Say we're full.
	#define COMPONENT_FULL_INDUCER (1<<2)
/// From base of /datum/proc/inducer_act: (obj/item/inducer/I, amount, inducer_flags)
#define COMSIG_INDUCER_ACT "inducer_act"
