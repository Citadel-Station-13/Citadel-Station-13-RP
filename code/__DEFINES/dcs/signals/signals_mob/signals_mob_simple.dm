/**
 *! ## Simple Mob Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

//! simple_animal signals
/// Called when a simplemob is given sentience from a potion (target = person who sentienced)
////#define COMSIG_SIMPLEMOB_SENTIENCEPOTION "simplemob_sentiencepotion"

//! /mob/living/simple_animal/hostile signals
/// Before attackingtarget has happened, source is the attacker and target is the attacked
////#define COMSIG_HOSTILE_PRE_ATTACKINGTARGET "hostile_pre_attackingtarget"
	////#define COMPONENT_HOSTILE_NO_ATTACK (1<<0) //cancel the attack, only works before attack happens
/// After attackingtarget has happened, source is the attacker and target is the attacked, extra argument for if the attackingtarget was successful
////#define COMSIG_HOSTILE_POST_ATTACKINGTARGET "hostile_post_attackingtarget"
/// From base of mob/living/simple_animal/hostile/regalrat: (mob/living/simple_animal/hostile/regalrat/king)
////#define COMSIG_RAT_INTERACT "rat_interaction"
/// From mob/living/simple_animal/hostile/ooze/eat_atom(): (atom/target, edible_flags)
////#define COMSIG_OOZE_EAT_ATOM "ooze_eat_atom"
	////#define COMPONENT_ATOM_EATEN  (1<<0)
