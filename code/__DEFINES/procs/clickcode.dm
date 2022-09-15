/**
 * flags passed around click procs including:
 * ClickOn
 * tool_act
 * attempt_dynamic_tool
 * melee_attack_chain
 * attackby
 * pre_attack
 * afterattack
 * MouseDrop
 * OnMouseDrop
 * MouseDroppedOn
 */

/// stop the click chain from proceeding past this point
#define CLICKCHAIN_DO_NOT_PROPAGATE			(1<<0)
/// person can reach us normally
#define CLICKCHAIN_HAS_PROXIMITY			(1<<1)
/// in tool act - used to check if we should do default proximity checks when none are specified
#define CLICKCHAIN_TOOL_ACT					(1<<2)
