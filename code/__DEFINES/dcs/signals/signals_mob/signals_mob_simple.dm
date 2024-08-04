/**
 *! ## Simple Mob Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

//! /mob/living/simple_animal/hostile signals
/// Before attackingtarget has happened, source is the attacker and target is the attacked
#define COMSIG_HOSTILE_PRE_ATTACKINGTARGET "hostile_pre_attackingtarget"
	#define COMPONENT_HOSTILE_NO_ATTACK (1<<0) //cancel the attack, only works before attack happens
/// After attackingtarget has happened, source is the attacker and target is the attacked, extra argument for if the attackingtarget was successful
#define COMSIG_HOSTILE_POST_ATTACKINGTARGET "hostile_post_attackingtarget"
