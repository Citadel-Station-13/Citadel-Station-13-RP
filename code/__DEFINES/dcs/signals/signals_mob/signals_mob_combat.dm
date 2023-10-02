/**
 *! ## Mob combat signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// sent when a mob resists
#define COMSIG_MOB_PROCESS_RESIST "mob_process_resist"
	#define COMPONENT_MOB_RESIST_INTERRUPT (1<<0)
