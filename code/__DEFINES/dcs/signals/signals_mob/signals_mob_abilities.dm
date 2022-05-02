/**
 *! ## Mob Ability Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// From base of /datum/action/cooldown/proc/PreActivate(): (datum/action/cooldown/activated)
////#define COMSIG_ABILITY_STARTED "mob_ability_base_started"
	////#define COMPONENT_BLOCK_ABILITY_START (1<<0)
/// From base of /datum/action/cooldown/proc/PreActivate(): (datum/action/cooldown/finished)
////#define COMSIG_ABILITY_FINISHED "mob_ability_base_finished"

/// From base of /datum/action/cooldown/mob_cooldown/blood_warp/proc/blood_warp(): ()
////#define COMSIG_BLOOD_WARP "mob_ability_blood_warp"
/// From base of /datum/action/cooldown/mob_cooldown/charge/proc/do_charge(): ()
////#define COMSIG_STARTED_CHARGE "mob_ability_charge_started"
/// From base of /datum/action/cooldown/mob_cooldown/charge/proc/do_charge(): ()
////#define COMSIG_FINISHED_CHARGE "mob_ability_charge_finished"
/// From base of /datum/action/cooldown/mob_cooldown/lava_swoop/proc/swoop_attack(): ()
////#define COMSIG_SWOOP_INVULNERABILITY_STARTED "mob_swoop_invulnerability_started"
/// From base of /datum/action/cooldown/mob_cooldown/lava_swoop/proc/swoop_attack(): ()
////#define COMSIG_LAVA_ARENA_FAILED "mob_lava_arena_failed"
