//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Clickchain Flags *//

/**
 * flags passed around click procs including but not limited to:
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
 * * These are default-additive. This means that most of the time, these all combine as we go down the chain without being
 *   reset.
 */

// todo: these flags are somewhat weird; infact, most of them are somewhat awful and need to be redone.
//       as an example, DO_NOT_PROPAGATE started as a "this thing's deleted, please stop engaging with it"
//       and an immediate abort.
//
//       but what if we want to communicate "hey, we did something, stop doing more things"?
//       example: screwdriver is usually used for construction but something wanted to override it
//       so it says "we're done here". that became the DID_SOMETHING flag, which is checked
//       for 'interaction continue'.
//
//       that, however, has its own issues. what if we want something triggering at end of
//       clickchain that reacts based on data? we want to differentiate between
//       1. "we were deleted but the user touched the entity",
//       2. "action completed but we were taken away / moved out of user",
//       3. "action halted by user when they realized they can't do something"
//          (e.g. "you don't have enough money to insert it into the vendor")
//       4. "action completed and the user wants to stop now but actually touched the entity"
//       5. "we were deleted but the user **did not** touch the entity"
//
//       this might all seem like semantics but if we ever add generic components that
//       need to hook on **any** contact of an item with an entity, this'll be needed.
//       door charges like the old /tg/ item are an example; we want it to engage on any contact,
//       not just on open.

/// stop the click chain from proceeding past this point; usually used if we're deleting or being inserted
///
/// * This is an unconditional abort.
/// * This should be used if an item will no longer be held by the user after the end of the proc.
///   This can happen from inserting something, deleting something, exploding something, etc.
#define CLICKCHAIN_DO_NOT_PROPAGATE			(1<<0)
/// person can reach us normally
#define CLICKCHAIN_HAS_PROXIMITY			(1<<1)
/// in tool attack chain - used to check if we should do default proximity checks when none are specified
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
// TODO: get rid of this and audit where it's used
#define CLICKCHAIN_COMPONENT_SIGNAL_HANDLED	(1<<8)
/// this is a reflex counterattack by something
///
/// * used to prevent loops where both parties reactively attack each other instantly.
#define CLICKCHAIN_REFLEX_COUNTER			(1<<9)
/// put this in if we should entirely abort the attack
#define CLICKCHAIN_FULL_BLOCKED				(1<<10)
/// always log
#define CLICKCHAIN_ALWAYS_LOG               (1<<11)

/// check these for 'unconditional abort'
#define CLICKCHAIN_FLAGS_UNCONDITIONAL_ABORT (CLICKCHAIN_DO_NOT_PROPAGATE)
/// check these for 'abort attack'
#define CLICKCHAIN_FLAGS_ATTACK_ABORT (CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_FULL_BLOCKED | CLICKCHAIN_DO_NOT_ATTACK)
/// check these for 'abort further interactions'
#define CLICKCHAIN_FLAGS_INTERACT_ABORT (CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_FULL_BLOCKED | CLICKCHAIN_DID_SOMETHING)

//*   Clickchain - melee_attack_chain() args                *//
//* These are used for comsig overrides.                    *//
//* These hold true for melee_attack_chain's                *//
//* sub-calls, including melee_attack() and melee_impact(). *//

#define CLICKCHAIN_MELEE_ATTACK_ARG_CLICKCHAIN 1
#define CLICKCHAIN_MELEE_ATTACK_ARG_CLICKCHAIN_FLAGS 2
#define CLICKCHAIN_MELEE_ATTACK_ARG_STYLE 3

//* Click param - Action. This is injected by CitRP code. *//

#define CLICK_PARAM_ACTION "action"

#define CLICK_ACTION_LMB "left"
#define CLICK_ACTION_CTRL_LMB "ctrl-left"
#define CLICK_ACTION_CTRL_SHIFT_LMB "ctrl-shift-left"
#define CLICK_ACTION_SHIFT_LMB "shift-left"
#define CLICK_ACTION_ALT_LMB "alt-left"

#define CLICK_ACTION_MMB "middle"
#define CLICK_ACTION_SHIFT_MMB "shift-middle"

#define CLICK_ACTION_RMB "right"
#define CLICK_ACTION_SHIFT_RMB "shift-rmb"

//* Reachability Depths *//

/// default reachability depth
#define DEFAULT_REACHABILITY_DEPTH			4

//* Reachability Returns *//

/// can't reach - this *must* be a fals-y value.
#define REACH_FAILED 0
/// can physically reach normally
#define REACH_PHYSICAL 1
/// can reach with something like telekinesis
#define REACH_INDIRECT 2
