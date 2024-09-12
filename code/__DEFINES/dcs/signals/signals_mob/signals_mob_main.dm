/**
 *! ## Mob Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// From base of obj/allowed(mob/M): (/obj) returns ACCESS_ALLOWED if mob has id access to the obj
// todo: this doesn't work
#define COMSIG_MOB_TRIED_ACCESS "tried_access"
	#define ACCESS_ALLOWED (1<<0)
	#define ACCESS_DISALLOWED (1<<1)
	#define LOCKED_ATOM_INCOMPATIBLE (1<<2)

/// From base of mob/can_block_magic(): (mob/user, casted_magic_flags, charge_cost)
#define COMSIG_MOB_RECEIVE_MAGIC "mob_receive_magic"
	#define COMPONENT_MAGIC_BLOCKED (1<<0)

/// From base of /mob/verb/examinate(): (atom/target)
#define COMSIG_MOB_EXAMINATE "mob_examinate"
/// From base of /mob/update_sight(): ()
#define COMSIG_MOB_UPDATE_SIGHT "mob_update_sight"
//// From /mob/living/say(): ()
#define COMSIG_MOB_SAY "mob_say"

/// Sent when a mob/login() finishes: (client)
#define COMSIG_MOB_CLIENT_LOGIN "comsig_mob_client_login"
/// Sent when a mob/logout() begins: (client)
#define COMSIG_MOB_CLIENT_LOGOUT "comsig_mob_client_logout"

/// From base of mob/Life(): (seconds, times_fired)
#define COMSIG_MOB_ON_LIFE			"mob_life"
	#define COMPONENT_INTERRUPT_PHYSICAL_LIFE			(1<<0)
	#define COMPONENT_INTERRUPT_BIOLOGICAL_LIFE			(1<<1)

/// From base of mob/PhysicalLife(): (seconds, times_fired)
#define COMSIG_MOB_PHYSICAL_LIFE "mob_physical_life"
/// From base of mob/BiologicalLife(): (seconds, times_fired)
#define COMSIG_MOB_BIOLOGICAL_LIFE "mob_biological_life"
