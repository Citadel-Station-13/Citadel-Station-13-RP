//! Clickchain Flags
/**
 * flags passed around click procs including:
 * ClickOn
 * melee_attack_chain
 * ranged_attack_chain
 * attackby
 * pre_attack
 * standard_melee_attack and related
 * attack_mob and related
 * attack_obj and related
 * afterattack
 * MouseDrop
 * OnMouseDrop
 * MouseDroppedOn
 *
 * These are *not* used for attack_hand, attack_robot, attack_xeno, and similar clicked-by-specific-mob attack procs.
 * These are also not used for attack_self, as that isn't even a true clickcode proc.
 */

/// stop the click chain from proceeding past this point; usually used if we're deleting or being inserted
/// DO NOT ABUSE THIS PROC TO INTERRUPT AFTERATTACKS WITHOUT CARE; this is NOT what this is here for!
#define CLICKCHAIN_DO_NOT_PROPAGATE			(1<<0)
/// person can reach us normally
#define CLICKCHAIN_HAS_PROXIMITY			(1<<1)
/// in tool act - used to check if we should do default proximity checks when none are specified
#define CLICKCHAIN_TOOL_ACT					(1<<2)
/// redirected by something - like when a switchtool to another item
#define CLICKCHAIN_REDIRECTED				(1<<3)
/// this is from tgui or the js statpanel - we should probably be paranoid
#define CLICKCHAIN_FROM_HREF				(1<<4)
/// did something in the proc, logically should stop using it (the user should anyways)
#define CLICKCHAIN_DID_SOMETHING			(1<<5)
/// completely block attacking (notably, attack_mob, attack_obj) from happening by halting standard_melee_attack.
#define CLICKCHAIN_DO_NOT_ATTACK			(1<<6)

//! Reachability Depths - checked from level of DirectAccess and turf adjacency.
/// default reachability depth
#define DEFAULT_REACHABILITY_DEPTH			3		// enough to reach into pill bottles in box in backpack
