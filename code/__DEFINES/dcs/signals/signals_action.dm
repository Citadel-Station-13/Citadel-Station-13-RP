/**
 *! ## Action Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

//# /datum/action signals
/// From base of datum/action/proc/Trigger(): (datum/action)
////#define COMSIG_ACTION_TRIGGER "action_trigger"
	////#define COMPONENT_ACTION_BLOCK_TRIGGER (1<<0)

//# Cooldown action signals

/// From base of /datum/action/cooldown/proc/PreActivate(), sent to the action owner: (datum/action/cooldown/activated)
////#define COMSIG_MOB_ABILITY_STARTED "mob_ability_base_started"
	/// Return to block the ability from starting / activating
	////#define COMPONENT_BLOCK_ABILITY_START (1<<0)
/// From base of /datum/action/cooldown/proc/PreActivate(), sent to the action owner: (datum/action/cooldown/finished)
////#define COMSIG_MOB_ABILITY_FINISHED "mob_ability_base_finished"
