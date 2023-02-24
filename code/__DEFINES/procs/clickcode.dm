//! Clickchain Flags
/**
 * flags passed around click procs including:
 * ClickOn
 * melee_attack_chain
 * ranged_attack_chain
 * attackby
 * pre_attack
 * afterattack
 * MouseDrop
 * OnMouseDrop
 * MouseDroppedOn
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

//! Reachability Depths - checked from level of DirectAccess and turf adjacency.
/// default reachability depth
#define DEFAULT_REACHABILITY_DEPTH			3		// enough to reach into pill bottles in box in backpack
