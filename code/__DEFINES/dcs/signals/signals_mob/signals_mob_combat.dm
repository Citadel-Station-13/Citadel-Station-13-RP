/**
 *! ## Mob combat signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// sent when a mob resists
#define COMSIG_MOB_PROCESS_RESIST "mob_process_resist"
	#define COMPONENT_MOB_RESIST_INTERRUPT (1<<0)

/// Sent when a mob throws something
#define COMSIG_MOB_ON_THROW "mob_on_throw"

/// Sent before the safety of the gun is checked
#define COMSIG_MOB_WEAPON_FIRE_ATTEMPT "mob_on_gunfire_attempt"

/// Sent in /obj/item/proc/melee_attack() and /obj/machinery/light/attackby()
#define COMSIG_MOB_ON_ITEM_MELEE_ATTACK "mob_on_item_melee"
