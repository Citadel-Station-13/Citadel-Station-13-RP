//! Clickchain Flags
/**
 * flags passed around click procs including:
 * ClickOn
 * melee_interaction_chain
 * ranged_interaction_chain
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

/// Unconditionally abort the chain of click handling procs past this point.
///
/// * This is an unconditional abort.
/// * This should be used if an item will no longer be held by the user after the end of the proc.
///   This can happen from inserting something, deleting something, exploding something, etc.
#define CLICKCHAIN_DO_NOT_PROPAGATE			(1<<0)
/// person can reach us normally
#define CLICKCHAIN_HAS_PROXIMITY			(1<<1)
/// in tool act - used to check if we should do default proximity checks when none are specified
/// this is added to clickchain flags by tool_attack_chain.
#define CLICKCHAIN_TOOL_ACT					(1<<2)
/// redirected by something - like when a switchtool to another item
#define CLICKCHAIN_REDIRECTED				(1<<3)
/// this is from tgui or the js statpanel - we should probably be paranoid
#define CLICKCHAIN_FROM_HREF				(1<<4)
/// did something in the proc, logically should stop using it (the user should anyways)
#define CLICKCHAIN_DID_SOMETHING			(1<<5)
/// attack missed
#define CLICKCHAIN_ATTACK_MISSED			(1<<6)
/// completely block attacking (notably, attack_mob, attack_obj) from happening by halting standard_melee_attack.
#define CLICKCHAIN_DO_NOT_ATTACK			(1<<7)
/// intercepted by component
#define CLICKCHAIN_COMPONENT_SIGNAL_HANDLED	(1<<8)
/// this is a reflex counterattack by something
///
/// * used to prevent loops where both parties reactively attack each other instantly.
#define CLICKCHAIN_REFLEX_COUNTER			(1<<9)
/// put this in if we should entirely abort the attack
#define CLICKCHAIN_FULL_BLOCKED				(1<<10)

/// check these for 'unconditional abort'
#define CLICKCHAIN_FLAGS_UNCONDITIONAL_ABORT (CLICKCHAIN_DO_NOT_PROPAGATE)
/// check these for 'abort attack'
#define CLICKCHAIN_FLAGS_ATTACK_ABORT (CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_FULL_BLOCKED)
/// check these for 'abort further interactions'
#define CLICKCHAIN_FLAGS_INTERACT_ABORT (CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING)

//! Reachability Depths - checked from level of DirectAccess and turf adjacency.
/// default reachability depth
#define DEFAULT_REACHABILITY_DEPTH			4

//! Reachability
/// can't reach - this *must* be a fals-y value.
#define REACH_FAILED 0
/// can physically reach normally
#define REACH_PHYSICAL 1
/// can reach with something like telekinesis
#define REACH_INDIRECT 2
