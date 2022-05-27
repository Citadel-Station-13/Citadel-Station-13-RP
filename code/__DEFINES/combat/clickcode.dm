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
#define CLICK_CHAIN_DO_NOT_PROPAGATE			(1<<0)

// TODO: roll proximity flags into this oh god oh fuck
